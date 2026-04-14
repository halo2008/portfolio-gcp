# Rozmowa — analiza oferty Cloud Engineer/Architect (GCP)

## Kontekst

Konrad dostał ofertę od rekruterki (Agata Maciejewska, ITFS) na stanowisko **Cloud Engineer/Architect (GCP)**:

- **Miejsce:** praca zdalna, okazjonalne wizyty w Gdańsku
- **Start:** ASAP (do 30 dni OW)
- **Forma:** B2B z ITFS
- **Stawka:** 170–190 zł/h netto + VAT
- **Proces:** rozmowa z ITFS → rozmowa miękko-techniczna z klientem → decyzja

### Wymagania z oferty

**Twarde:**
- Min. 4 lata doświadczenia na podobnym stanowisku
- Bardzo dobra znajomość GCP (cert mile widziany)
- Compute Engine, GKE, konteneryzacja/orkiestracja
- Cloud-native networking (VPC, peering, firewall, sieci kontenerowe)
- Bezpieczeństwo i governance (IAM, kontrola dostępu)
- Monitoring, logowanie, alertowanie
- Terraform / IaC (moduły, zmienne, wersjonowanie)
- Git, GitLab/Jenkins, CI/CD
- Angielski min. B2

**Mile widziane:** Linux, Bash/Python, K8s/Docker/Helm, GitOps, Grafana/ELK/Splunk

### Aktualna sytuacja Konrada
- Obecne zarobki: do 8k
- Formalnie DevOps od 08.2025 (9 mies.)
- Wcześniej ~3 lata Full Stack z elementami infra (ULAMEX)
- Posiada produkcyjny projekt **erp-prod-gke** (pełna infra GCP + GKE w Terraformie)
- Portfolio GCP (Cloud Run + WIF + GitHub Actions)
- Przerabia Google Cloud Skills Boost
- Pracuje "viebowo" (heavy use AI), ma syndrom oszusta

---

## Analiza dopasowania do oferty

### Twarde wymagania — ocena

| Wymaganie | Status | Ocena |
|---|---|---|
| Min. 4 lata na podobnym stanowisku | DevOps 9 mies. + ~3 lata full stack z infra | ⚠️ Formalnie za mało |
| GCP (cert mile widziany) | Portfolio-gcp + Google Cloud Skills Boost w toku, brak certa | ⚠️ Praktyka jest, bez certa |
| Compute Engine / GKE | GKE produkcyjnie (erp-prod-gke), multi-tenant, hardening | ✅ Mocna strona |
| Konteneryzacja/orkiestracja | Helm, Kyverno, Calico, Vault, ESO | ✅ Bardzo mocno |
| Cloud-native networking | Calico network policies, Ingress/ModSecurity | ✅ K8s tak, GCP VPC/peering słabiej |
| IAM, governance | Zitadel+OIDC, WIF w portfolio-gcp | ✅ OK |
| Monitoring/logging/alerting | Prometheus, Grafana, Loki, Jaeger, OTel | ✅ Mocno |
| Terraform / IaC | ULAMEX + portfolio-gcp + erp-prod-gke | ✅ OK |
| Git, CI/CD | GitHub Actions (lmw-deploy), git | ✅ OK (brak GitLab/Jenkins ale to tylko narzędzia) |
| Angielski B2 | — | ❓ Do potwierdzenia |

**Mile widziane:** Linux ✅, Bash ✅, Docker/K8s/Helm ✅, Grafana ✅, GitOps ⚠️

### Co realnie jest w `erp-prod-gke`

**01-infra** — produkcyjna infra GCP w Terraformie:
- VPC, firewall, Cloud SQL, Secret Manager
- GKE cluster
- Workload Identity Federation
- Artifact Registry, billing, Pub/Sub
- Observability storage

**02-apps** — warstwa aplikacyjna K8s przez Terraform:
- K8s operators, system apps, Zitadel (OIDC/SSO)
- Network policies (Calico)
- External DNS, CDC, pgbouncer
- Pełny stack observability (core, storage, OTel, network policy, pg-exporter)

To **nie jest portfolio juniora** — to produkcyjna architektura GCP na poziomie senior Cloud Engineer.

### Werdykt dopasowania: ~90%

Jedyne co kuleje to formalny staż. Kontrargument: *"formalnie DevOps od 9 miesięcy, ale samodzielnie zaprojektowałem i utrzymuję produkcyjny klaster GKE z pełnym IaC, WIF, observability i SSO"*.

---

## Ekonomia oferty

- 168h/mies. × 180 zł = **~30k netto** (B2B, przed ZUS/księgowością)
- Vs. obecne 8k = **~3,5-4x** wzrost
- Nawet po odjęciu ZUS (~1600 zł) i księgowości (~200 zł) zostaje ~25k+ na rękę
- Na B2B brak płatnego urlopu/L4 — do uwzględnienia

**Nawet przy zbiciu stawki do 140-150 zł/h to wciąż ~25k netto = 3x więcej niż teraz.**

---

## Draft odpowiedzi do rekruterki

> **Temat:** Re: Cloud Engineer/Architect (GCP) — zainteresowanie
>
> Cześć Agata,
>
> Dzięki za wiadomość — oferta bardzo mnie interesuje, stack i tryb pracy pasują do tego, co robię na co dzień.
>
> Krótko o dopasowaniu:
>
> - **GCP + Terraform produkcyjnie:** projektuję i utrzymuję klaster GKE wraz z pełną warstwą infrastruktury w IaC (VPC, Cloud SQL, Secret Manager, Artifact Registry, Workload Identity Federation, Pub/Sub, observability storage). Podział na warstwy infra/apps, Terraform + Helm.
> - **K8s / platform engineering:** Calico network policies (default-deny), Kyverno (Policy-as-Code), HashiCorp Vault + External Secrets Operator, ModSecurity/OWASP CRS na Ingressie, Zitadel jako OIDC/SSO.
> - **Observability:** Prometheus, Grafana, Loki, Jaeger, OpenTelemetry — wdrożone end-to-end.
> - **CI/CD + GCP-native:** osobne portfolio z Cloud Run, Workload Identity Federation i GitHub Actions (bez kluczy serwisowych).
> - Aktualnie przerabiam **Google Cloud Skills Boost** pod certyfikację GCP.
>
> Stawka 170–190 zł/h netto + VAT — akceptuję.
> Terminy na rozmowę w tym tygodniu: [wpisz 2-3 sloty].
>
> CV w załączniku. Chętnie pokażę architekturę projektów na rozmowie technicznej.
>
> Pozdrawiam,
> Konrad Siedkowski

### Zasady odpowiedzi
1. Wpisz realne terminy (2-3 sloty)
2. CV dołącz lub "prześlę do końca dnia"
3. **Nie negocjuj stawki** w pierwszym mailu
4. **Nigdy nie wspominaj obecnej stawki 8k** — na pytanie o obecne zarobki: *"To była inna forma zatrudnienia (UoP), wolę rozmawiać o oczekiwaniach — widełki z oferty mi odpowiadają."*

---

## Co to jest rozmowa "miękko-techniczna"

Hybryda HR + techniczna, bez live codingu.

**Część miękka (~40-50%):**
- Dlaczego zmiana pracy
- Praca w zespole, komunikacja
- Doświadczenie ze stakeholderami
- Oczekiwania, dostępność, tryb pracy
- Czasem kilka pytań po angielsku (sprawdzenie B2)

**Część techniczna (~50-60%):**
- Opowiedz o projekcie na którym pracujesz (→ **erp-prod-gke**)
- Pytania otwarte: "Jak zaprojektowałbyś X?", "Jak debugowałeś Y?"
- Dyskusja o technologiach z CV
- Scenariusze: "Aplikacja wolno działa, co robisz?"
- **Bez** zadań live, bez algorytmów

### Przygotowanie do rozmowy
1. 3-minutowy elevator pitch o `erp-prod-gke` — architektura, decyzje, wnioski
2. 2-3 historie STAR:
   - Wdrożenie Vault + ESO
   - Migracja VPS → GKE
   - Kyverno policies / hardening
3. Przećwicz "opowiedz o sobie" (max 2 min)
4. Przygotuj 2-3 pytania do nich: struktura zespołu, ich GCP, tech lead, wyzwania
5. Na pytania których nie wiesz: *"Nie miałem z tym styczności w produkcji, ale znam koncept — [krótko] — chętnie nadrobię"*

---

## Syndrom oszusta — "vibe coding" i strach przed seniorską stawką

### "Vibe coding" ≠ brak kompetencji

Używanie AI do pisania kodu to dziś **standard w całej branży**, łącznie z seniorami w FAANG. Różnica między junior-vibe-coderem a senior-vibe-coderem:

- Czy **rozumiesz** co AI wygenerowało (czytasz, debugujesz, modyfikujesz)
- Czy umiesz **ocenić** czy to dobre rozwiązanie
- Czy wiesz **dlaczego** tak, a nie inaczej
- Czy umiesz to **utrzymać** jak się zepsuje

Fakt że `erp-prod-gke` **działa w produkcji** to dowód że te kompetencje są. Produkcyjny GKE z Vault, Kyverno, Calico i observability nie stoi sam z siebie — ktoś musi go naprawiać.

### Seniorska stawka ≠ seniorska wiedza encyklopedyczna

170-190 zł/h w Polsce w 2026 to dobra mid/senior stawka, nie top-tier architect. Klient oczekuje:
- Działającego rozwiązania
- Żebyś nie wywalił produkcji
- Komunikacji i zadawania pytań
- Uczenia się tego czego nie wiesz

### Ryzyko jest asymetryczne na Twoją korzyść

- **Najgorzej:** nie przejdziesz → zostajesz na 8k, zyskujesz doświadczenie z rozmowy
- **Średnio:** przejdziesz, po 3 miesiącach za trudne → wracasz z wpisem "Cloud Engineer" w CV + realnym doświadczeniem komercyjnym GCP
- **Najlepiej:** ogarniasz, zarabiasz 3-4x więcej, rozwijasz się szybciej

**Żaden scenariusz nie jest gorszy niż zostanie na 8k.**

### Co zrobić z tym strachem

1. Przestań porównywać się do wyimaginowanego "prawdziwego seniora". Seniorzy też googlują i pytają AI.
2. Na rozmowie o metodach pracy:
   - ❌ "Ja to wszystko robię z AI, nic sam nie umiem"
   - ✅ "Intensywnie używam AI jako narzędzia — przyspiesza mnie 3-5x. Ale kod przechodzi przeze mnie, rozumiem decyzje, utrzymuję w produkcji."
3. Przed rozmową: otwórz `erp-prod-gke/01-infra` i przez 2h przeczytaj każdy plik TF **bez AI**. Nie na pamięć — żeby mieć świeżą mapę w głowie.
4. **Rekruterka sama napisała do Ciebie.** To nie Ty się wpraszasz — oni zapraszają.

### Pointa

Strach przed "nie zasługuję" zatrzyma Cię na 8k na kolejne 5 lat. Ludzie którzy awansują to ci którzy aplikują gdy czują że to trochę za wysoko i dorastają w locie.

**Wyślij tego maila. Dzisiaj.**

---

## Podsumowanie plików które widziałem

### `/home/konrad-sedkowski/code/portfolio-gcp` (bieżący katalog)
- `infra/cloud_run.tf:21` — `min_instance_count = 0` (Cloud Run skaluje się do zera, potwierdzone)
- Z git log: WIF bez kluczy serwisowych, Artifact Registry z retention = 3, CPU throttling na Cloud Run, Terraform dla pełnego stacku

### `/home/konrad-sedkowski/code/erp-prod-gke`
Struktura: `01-infra`, `02-apps`, `k8s-gcp`, `Makefile`, `scripts`, `test-debug`

**`01-infra/`** (pełna infra GCP w Terraformie):
- `00-main.tf`, `variables.tf`, `outputs.tf` — provider + konfiguracja
- `01-vpc.tf` — sieć VPC
- `02-cloud-sql.tf` — zarządzana baza PostgreSQL
- `03-security.tf` — polityki bezpieczeństwa
- `04-secrets-manager.tf` — GCP Secret Manager
- `05-firewall.tf` — reguły firewall
- `06-gke-cluster.tf` — klaster GKE
- `08-artifact-registry.tf` — rejestr obrazów
- `09.billing.tf` — budget/alerty billing
- `11-workload_identity.tf` — Workload Identity (bez kluczy SA)
- `12-observability-storage.tf` — storage pod logi/metryki
- `13-pubsub.tf` — Pub/Sub
- `14-ai-agent.tf` — komponenty AI
- `readme.md`, `plan.out`

**`02-apps/`** (warstwa aplikacyjna K8s przez Terraform):
- `00-main.tf`, `variables.tf`
- `06-pgbouncer-custom.tf` — pooler PG
- `07-k8s-operators.tf` — operatory K8s
- `08-k8s-config.tf` — konfiguracja klastra
- `10-k8s-system-apps.tf` — aplikacje systemowe
- `11-zitadel.tf` — Zitadel (OIDC/SSO)
- `12-network-policies.tf` — Calico network policies
- `13-external-dns.tf` — External DNS
- `14-db-init.tf`, `15-db-fix-permissions.tf` — init bazy
- `15-cdc.tf` — Change Data Capture
- `16-observability-secrets.tf`, `17-observability-core.tf`, `18-observability-storage.tf`, `19-observability-otel.tf`, `20-observability-network-policy.tf` — pełny stack obserwowalności + OTel
- `21-pg-exporter.tf` — exporter metryk Postgresa

**`k8s-gcp/`**: `gateway`, `helm` — manifesty i chart Helm

### `/home/konrad-sedkowski/code/google/lmw-deploy`

**`deploy-backend/`**:
- `deploy_backend.sh` — skrypt deploymentu backendu
- `erp-system/` — katalog projektu
- `forex-scalping-plan.md`
- zrzuty ekranu

**`deploy-forntend/`** (literówka w nazwie):
- `deploy_frontend.sh` — skrypt deploymentu frontendu
- `backups/` — backupy
- `VPS-front-2-prod/` — projekt frontu

### Ogólny wniosek

Masz w jednym miejscu **pełną produkcyjną architekturę GCP** (od VPC przez Cloud SQL i GKE po WIF i observability), rozbitą na dwie warstwy Terraforma (infra + apps), z hardeningiem K8s, SSO przez Zitadel i pełnym stackiem obserwowalności. To realne portfolio seniorskie, nie hobbystyczne — i dokładnie to, czego szuka oferta.

---

## TODO (pomysły na później)

- Zrefaktorować `erp-prod-gke` na reużywalne moduły Terraform (`gke-cluster`, `observability-stack`, `network-policies`) — zwiększy reużywalność
- Dokończyć Google Cloud Skills Boost → cert GCP
- Zaktualizować CV o bullety dot. `erp-prod-gke` jako projekt produkcyjny
