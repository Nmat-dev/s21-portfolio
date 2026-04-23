# Nginx Log Generator

## HTTP Response Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Request successfully completed |
| 201 | Created | Resource successfully created (after POST/PUT) |
| 400 | Bad Request | Invalid request syntax |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Access denied (no permissions) |
| 404 | Not Found | Resource not found |
| 500 | Internal Server Error | Server-side error |
| 501 | Not Implemented | Method not supported |
| 502 | Bad Gateway | Invalid response from upstream server |
| 503 | Service Unavailable | Server temporarily unavailable |

## Usage

```bash
./main.sh [num_files] [min_entries] [max_entries]