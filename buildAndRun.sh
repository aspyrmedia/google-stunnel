#!/bin/bash
docker-compose down -t 1; docker-compose build && docker-compose up -d && docker-compose logs -f