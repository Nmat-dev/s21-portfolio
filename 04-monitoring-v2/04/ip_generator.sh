#!/bin/bash

generate_ip() {
    local octet1=$((RANDOM % 223 + 1))    # 1-223 (не начинается с 0, не 224+)
    local octet2=$((RANDOM % 256))         # 0-255
    local octet3=$((RANDOM % 256))         # 0-255
    local octet4=$((RANDOM % 254 + 1))     # 1-254 (не 0 и не 255)
    
    echo "${octet1}.${octet2}.${octet3}.${octet4}"
}