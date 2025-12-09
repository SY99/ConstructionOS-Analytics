# 🏗️ ConstructionOS

**Construction Progress & Material Management – Analytics Proof of Concept**

---

## 📌 Overview

**ConstructionOS** is a **proof-of-concept construction analytics system** designed to track **project progress and material inventory** for a residential construction project.

This project is inspired by my **real on-site experience as an architect**, translated into a **data-driven monitoring system** using:

- SQL (backend logic & data modeling)
- Power BI (reporting & visualization)
- Simulated but **workflow-accurate construction data**

The goal was **not** to build a data entry app, but to demonstrate how **construction operations can be monitored, audited, and analyzed** using structured data and dashboards.

---

## 🎯 Project Objectives

- ✅ Design a **realistic construction database schema**
- ✅ Simulate on-site workflows (engineer updates, inventory transactions)
- ✅ Implement backend logic (triggers, stock rollups)
- ✅ Build **decision-oriented dashboards**, not just charts
- ✅ Create a portfolio project suitable for:
  - Data Analytics Internships
  - MBA Research (proof-of-concept)
  - Construction / Operations Analytics roles

---

## 🏗️ Real-World Context (What This Represents)

| Role            | Real-life Action               | System Representation   |
|-----------------|--------------------------------|--------------------------|
| Site Engineer   | Updates flat work progress     | `progress_tracking`     |
| Storekeeper     | Records material receipt/issue | `material_transactions` |
| Project Manager | Reviews progress & stock       | Power BI dashboards     |
| Management      | Looks at summaries             | Executive view          |

All data is **simulated**, but flows exactly like a real construction site.

---

## 🗃️ Database Design (MySQL)

The backend is a **relational MySQL database** with **16 tables**, representing a realistic residential construction workflow.

### 📁 Structural Hierarchy
- Projects  
- Wings  
- Floors  
- Flats  

### 📁 Progress Tracking
- Task_Master  
- Subtask_Master  
- Progress_Status  
- Progress_Tracking  

### 📁 Materials & Inventory
- Material_Inventory  
- Material_Transactions  
- Material_Stock_Summary  

### 📁 Users & Governance
- Users  
- Contractors  
- Departments  

### 📁 RCC Activity (experimental, not visualized here)
- RCC_Slab_Sheet  
- RCC_Column_Sheet  

Primary & foreign keys were designed to **mirror real construction dependencies** (Wing → Floor → Flat).

---

## ⚙️ Backend Logic (Key Design Choice)

Material stock is **NOT calculated in Power BI**.

Instead:
- MySQL **triggers** automatically update material stock based on transactions.

### ✔ Example Logic
- Opening Stock → Material added  
- Received Qty → Increases stock  
- Issued Qty → Reduces stock  
- Stock Summary table maintains latest balance  

Power BI is used **only for reporting**, respecting real-world system separation between systems.

---

## 📊 Dashboards Built (Power BI)

### 1️⃣ Executive Summary

**Purpose:** High-level view for management

**Key Insights:**
- Overall project progress %
- Completed vs In-progress flats
- Material stock value overview
- Contractor count
- Progress trends over time

---

### 2️⃣ Flat Progress Tracker

**Purpose:** Detailed operational view per flat

**Features:**
- Wing → Floor → Flat drilldown
- Task & subtask-wise progress tracking
- Status-based filtering (Not Started → Completed)
- Flat-level KPIs:
  - Completion %
  - In-progress subtasks
  - Last updated date
- Daily progress trend line
- Task-level progress table

This dashboard mimics how a **site engineer or project manager reviews work at a flat level**.

---

### 3️⃣ Material Inventory Dashboard

**Purpose:** Stock visibility & control

**Features:**
- Opening, Received, Issued, and Current stock KPIs
- Stock Level classification (Low / Medium / High)
- Material-wise issued vs received visualization
- Conditional formatting for low-stock materials
- Category, unit, and level-based slicers
- Clear separation between **transactions** and **stock state**

Designed primarily for **storekeepers and project managers**.

---

## 🧠 Analytics & DAX Highlights

- Custom measures for:
  - Average progress per flat
  - Latest subtask-level progress aggregation
  - Context-aware KPIs using slicers
- Usage of `HASONEVALUE()` to control KPI visibility
- Avoided unnecessary recomputation in Power BI
- Logic aligned carefully with backend SQL behavior

---

## 🛠️ Tools & Technologies

| Layer           | Technology                   |
|-----------------|-----------------------------|
| Database        | MySQL                       |
| Data Modeling   | Relational schema + triggers|
| Analytics       | Power BI                    |
| Query Logic     | SQL                         |
| Measures        | DAX                         |
| Version Control | GitHub                      |

---

## 📚 MBA Research Use Case

This project acts as a **virtual proof-of-concept** for applying analytics in construction project management.

It demonstrates:
- Process mapping
- Information flow design
- Data-backed decision making
- Operational transparency through dashboards

---

## 🚧 Limitations & Future Work

### Current Limitations
- Data is simulated
- RCC activity not fully visualized
- No frontend / data entry layer yet

### Planned Enhancements
- Web-based frontend (HTML/CSS/JS)
- API-based data ingestion
- User-role based access control
- Predictive delay & material forecasting

---

## ✅ Key Learning Outcomes

- Translating **domain experience into data models**
- Handling **complex relational schemas**
- Designing dashboards for **decision-makers**
- Understanding Power BI as a **reporting layer**, not a database
- Managing scope and delivery under tight deadlines

---

## 👤 About the Author

I am an MBA student with a background in **architecture and construction**, transitioning into **data analytics and finance**.

ConstructionOS reflects:
- On-site operational understanding
- Analytics-oriented problem solving
- Practical, real-world system thinking

---

## ⭐ Closing Note

ConstructionOS is intentionally **simple, realistic, and honest**.

It reflects how real construction systems operate — not how idealized tutorials present them.
