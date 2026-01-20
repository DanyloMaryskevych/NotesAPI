# Notes API

Workshop demo application for AWS ECS deployment.

## Purpose

This is a simple Notes API built for learning AWS ECS (Fargate) deployment patterns, including:

- Container orchestration with ECS Fargate
- Database connectivity with RDS PostgreSQL (IAM authentication)
- CDN and SSL with CloudFront and ACM
- CI/CD with GitHub Actions and OIDC
- Infrastructure as Code with Terraform

## Architecture

```
CloudFront → ALB → ECS Fargate → RDS PostgreSQL
```

## Domain

https://notes.cloud-concepts.org
