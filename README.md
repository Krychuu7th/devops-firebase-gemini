# devops-firebase-gemini
Repo utworzone w ramach prac chapterowych (DevOps - Firebase &amp; Gemini)


## Wdrażanie aplikacji Firebase z wykorzystaniem Terraform'a

### 1. Zaloguj się do Google Cloud i ustaw odpowiedni projekt

```bash
gcloud auth login
gcloud config set project devops-firebase-gemini-tf
```

### 2. Konfiguracja infrastruktury Terraform'a

```bash
cd terraform
terraform init
```

### 3. Zastosowanie konfiguracji Terraform'a

```bash
terraform apply
```

### 4. Wygeneruj konfigurację Firebase dla aplikacji Angular

```bash
terraform output -raw firebase_config
```

### 5. Skopiuj wygenerowaną konfigurację do pliku `environment.ts`

### 6. Zbuduj aplikację Angular

```bash
cd ../dfg-front
ng build -c production
```

### 7. Wdróż aplikację na Firebase Hosting

```bash
firebase login
firebase deploy --only hosting --project=devops-firebase-gemini-tf
```

### 8. Zrobione!!!🎉

Apka powinna być dosępna pod adresem: https://devops-firebase-gemini-tf.web.app/ lub https://devops-firebase-gemini-tf.firebaseapp.com/


#### UWAGA!!!
Niektóre niektóre kroki takie jak ustawienie rulesetów bazy danych Firestore mogą wymagać ręcznej interwencji w konsoli Firebase.
Wynika to z ograniczeń Terraform'a w zakresie zarządzania regułami bezpieczeństwa Firestore.
Podobnie jest w przypadku aktywacji usług Firebase AI Logic, które muszą zostać włączone ręcznie w konsoli Firebase.
