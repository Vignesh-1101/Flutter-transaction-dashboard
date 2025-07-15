# Flutter Fintech Dashboard & Payout App

A modern Flutter app demonstrating a transaction dashboard with filtering, animated detail view, payout form with validation, and payout history using local storage. Built for interview/assessment tasks.

---

## 🚀 Features

- **Transaction Dashboard**
  - Fetches transactions from a public REST API (Dio)
  - ListView with amount, date, type, and status
  - Filter by date range and status
  - Tap a transaction for a detailed, animated view
- **Payout Form**
  - Fields: Beneficiary Name, Account Number, IFSC, Amount
  - Full validation (amount > ₹10 and < ₹1,00,000, IFSC format, etc.)
  - On submit, saves payout to local storage (Hive)
- **Payout History**
  - View all past payout requests
  - Data persists across app restarts
- **State Management**: Provider
- **Modern UI**: Clean, responsive, and production-ready

---

## 🛠️ Tech Stack
- **Flutter** (null safety)
- **Provider** (state management)
- **Dio** (API calls)
- **Hive** (local storage)

---

## 📦 Setup & Run

1. **Clone the repo:**
   ```sh
   git clone <your-repo-url>
   cd <your-repo-folder>
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Generate Hive adapters:**
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Run the app:**
   ```sh
   flutter run
   ```
   > **Note:** For Android, ensure you have `<uses-permission android:name="android.permission.INTERNET"/>` in `AndroidManifest.xml`.

---

## 📱 Usage
- **Dashboard:** View and filter transactions. Tap any row for details.
- **Payout:** Tap the "Payout" button to submit a new payout.
- **History:** Tap the history icon in the AppBar to view all past payouts.

---