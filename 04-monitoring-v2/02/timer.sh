#!/bin/bash

start_timer() {
    START_TIME=$(date +%s)
    START_DATE=$(date +"%Y-%m-%d %H:%M:%S")
}

end_timer() {
    END_TIME=$(date +%s)
    END_DATE=$(date +"%Y-%m-%d %H:%M:%S")
    DURATION=$((END_TIME - START_TIME))
}

print_timer() {
    echo "Start time: $START_DATE"
    echo "End time: $END_DATE"
    echo "Duration: ${DURATION} seconds"
}

log_timer() {
    echo "Start time: $START_DATE" >> "$LOG_FILE"
    echo "End time: $END_DATE" >> "$LOG_FILE"
    echo "Duration: ${DURATION} seconds" >> "$LOG_FILE"
}