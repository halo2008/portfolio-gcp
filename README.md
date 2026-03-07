# 🚀 Konrad Sędkowski Portfolio Engine (Infra)

[![Terraform](https://img.shields.io/badge/Infrastructure-Terraform-623CE4?logo=terraform)](https://www.terraform.io/)
[![Google Cloud](https://img.shields.io/badge/Cloud-GCP-4285F4?logo=google-cloud)](https://cloud.google.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An enterprise-grade, cloud-native infrastructure setup for a high-performance portfolio ecosystem. This repository manages the deployment of serverless backends, AI integrations, vector databases, and comprehensive observability stacks on Google Cloud Platform.

---

## 🏗️ Architecture & Vision

This repository serves as the **Infrastructure-as-Code (IaC)** backbone for `ks-infra.dev`. It is designed with a focus on **scalability**, **security**, and **automated observability**.

### Key Pillars
- **Hexagonal Architecture**: decoupling core business logic from cloud-specific infrastructure.
- **Serverless First**: leveraging Google Cloud Run for elastic scaling and cost-efficiency.
- **AI-Native**: integrated with Google Gemini for advanced document processing and automation.
- **RAG Capability**: utilizing Qdrant vector database for specialized semantic search.

---

## 🛠️ Technology Stack

### Core Infrastructure
- **Provider**: Google Cloud Platform (GCP)
- **IaC**: Terraform (Modular design)
- **Deployment**: Google Cloud Run (v2)
- **Networking**: Cloud Run Domain Mapping (+ Custom Domain `ks-infra.dev`)
- **Security**: Workload Identity Federation (WIF), Secret Manager, ReCAPTCHA Enterprise

### Application Integration
- **Database**: Firestore (NoSQL, Serverless)
- **LLM**: Google Gemini (via Vertex AI / Gemini API)
- **Vector DB**: Qdrant (Self-hosted/Managed integration)
- **Integrations**: Slack API, Gmail API, Useme (Freelance platform polling)

### Observability (Full-Stack)
- **Logging**: Grafana Loki
- **Metrics**: Prometheus / Grafana Managed Metrics (Remote Write)
- **Alerting**: Slack Notification Channels

---

## 🔒 Security & CI/CD

The pipeline uses **Zero-Trust** principles:
- **GitHub Actions**: Automated CI/CD flow.
- **Workload Identity Federation**: No static keys for GCP authentication; uses OIDC for short-lived tokens.
- **Secret Management**: All sensitive data (Gemini keys, Slack tokens) is strictly managed via Google Secret Manager and injected at runtime.

---

## 🚀 Getting Started

### Prerequisites
- Terraform `>= 1.5.0`
- Google Cloud SDK (`gcloud`)
- A GCP Project ID

### Initial Deployment

1. **Initialize Terraform**:
   ```bash
   cd infra/
   terraform init
   ```

2. **Configure Variables**:
   Create a `terraform.tfvars` file or set environment variables for:
   - `project_id`
   - `region`
   - `app_name`

3. **Plan & Apply**:
   ```bash
   terraform plan
   terraform apply
   ```

---

## 📊 Infrastructure Layout

```text
infra/
├── apis.tf             # GCP Service-level APIs enablement
├── cloud_run.tf        # Cloud Run Service configuration & Probes
├── firestore.tf        # Database definition
├── iam.tf              # Service Accounts & Role Bindings
├── secrets.tf          # Secret Manager declarations
├── wif.tf              # Workload Identity Federation (GitHub)
└── variables.tf        # Configurable parameters
```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  Built with ❤️ by <b>Konrad Sędkowski</b>
</p>
