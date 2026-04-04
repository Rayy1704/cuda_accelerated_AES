#include "aes.h"

static const unsigned char mix_matrix[4][4] = {
    {0x02, 0x03, 0x01, 0x01},
    {0x01, 0x02, 0x03, 0x01},
    {0x01, 0x01, 0x02, 0x03},
    {0x03, 0x01, 0x01, 0x02}
};

void sub_bytes(aes_state*state){
    for(int r=0;r<4;r++){
        for(int c=0;c<4;c++){
            state->matrix[r][c]=sbox[state->matrix[r][c]]; // Select the byte from the sbox using the current byte as an index
        }
    }
}

void shift_rows(aes_state* state) {
    unsigned char temp;

    // Row 1: Left shift by 1 ([0,1,2,3] -> [1,2,3,0])
    temp = state->matrix[1][0];
    state->matrix[1][0] = state->matrix[1][1];
    state->matrix[1][1] = state->matrix[1][2];
    state->matrix[1][2] = state->matrix[1][3];
    state->matrix[1][3] = temp;

    // Row 2: Left shift by 2 ([0,1,2,3] -> [2,3,0,1])
    unsigned char t0 = state->matrix[2][0];
    unsigned char t1 = state->matrix[2][1];
    state->matrix[2][0] = state->matrix[2][2];
    state->matrix[2][1] = state->matrix[2][3];
    state->matrix[2][2] = t0;
    state->matrix[2][3] = t1;

    // Row 3: Left shift by 3 (Equivalent to Right shift by 1)
    temp = state->matrix[3][3];
    state->matrix[3][3] = state->matrix[3][2];
    state->matrix[3][2] = state->matrix[3][1];
    state->matrix[3][1] = state->matrix[3][0];
    state->matrix[3][0] = temp;
}

void mixcolumns(aes_state*state){
    for (int i=0;i<4;i++){
        unsigned char col[4];
        for (int j=0;j<4;j++){
            col[j]=state->matrix[j][i]; // Extract the current column from the state matrix
        }
        
        for(int j=0;j<4;j++){
            state->matrix[j][i]=
             multiply(mix_matrix[j][0],col[0])
            ^multiply(mix_matrix[j][1],col[1])
            ^multiply(mix_matrix[j][2],col[2])
            ^multiply(mix_matrix[j][3],col[3]); // Multiply the current column by the mix matrix and XOR it back into the state
        }
    }
}
void encryption_process(aes_state state,unsigned char *data,unsigned char *expanded_keys,size_t t){
    populate_state(&state, data+t); // Populate the state matrix with the input data (16 bytes for AES-128)
        // Initial AddRoundKey
        add_round_key(&state, expanded_keys, 0);
        // 9 main rounds of AES (SubBytes, ShiftRows, MixColumns, AddRoundKey)
        for(int i=0;i<9;i++){
            sub_bytes(&state); //Subbytes transformation
            shift_rows(&state); //ShiftRows transformation
            mixcolumns(&state); //MixColumns transformation
            add_round_key(&state,expanded_keys,i+1); //AddRoundKey transformation with the next round key
        }
        // Final round (without MixColumns)
        sub_bytes(&state); //Subbytes transformation
        shift_rows(&state); //ShiftRows transformation
        add_round_key(&state,expanded_keys,10); //AddRoundKey transformation with the final round key (round 10)
        // Copy the encrypted state back to the data buffer
        for (int c = 0; c < 4; c++) {
            for (int r = 0; r < 4; r++) {
                data[t+c * 4 + r] = state.matrix[r][c]; // Copy the state matrix back to the data buffer in column-major order
            }
        }
}
// __global__ void aes_encrypt_kernel(unsigned char * data, unsigned char* expanded_keys, size_t len){
//     int idx=blockIdx.x*blockDim.x+threadIdx.x; // Calculate the global thread index
//     int offset=idx*16; // Each thread processes a 16-byte block of data
//     if(offset<len){ // Ensure we don't go out of bounds
//         aes_state state;
//         encryption_process(state, data, expanded_keys, offset); // Call the encryption process for the assigned block of data
//     }
// }

void aes_encrypt(unsigned char * data,unsigned char * expanded_keys, size_t len){
    unsigned char * d_data;
    unsigned char * expanded_keys_device;
    size_t data_size=len*sizeof(unsigned char);
    size_t keys_size=176*sizeof(unsigned char); // 176 bytes for AES-128
    // Allocate memory on the device for data and expanded keys
    cudaMalloc(&d_data, data_size);
    cudaMalloc(&expanded_keys_device, keys_size);
    // Copy data and expanded keys from host to device
    cudaMemcpy(d_data, data, data_size, cudaMemcpyHostToDevice);
    cudaMemcpy(expanded_keys_device, expanded_keys, keys_size, cudaMemcpyHostToDevice);
    // Calculate grid and block dimensions
}
