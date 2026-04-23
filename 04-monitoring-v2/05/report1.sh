#!/bin/bash

report_by_status() {
    local log_file="$1"
    
    sort -t' ' -k9,9n "$log_file"
}