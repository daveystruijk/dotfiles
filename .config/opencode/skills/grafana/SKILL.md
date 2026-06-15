---
name: grafana
description: Create and troubleshoot Grafana dashboards and queries for Momo's live databases (PostgreSQL, InfluxDB, VictoriaMetrics, Timestream, Athena, CloudWatch). Use when the user mentions Grafana, dashboards, panels, queries, metrics, or monitoring.
---

# Grafana Dashboard & Query Guide for Momo

Use this skill when helping a user create, modify, or troubleshoot Grafana dashboards and queries against Momo's live data. This covers all available datasources: PostgreSQL, InfluxDB, VictoriaMetrics, Timestream, Athena, and CloudWatch.

## How to Use This Skill

When the user wants to build a Grafana dashboard or panel:

1. **Clarify what they want to see** — which metric, for which audience, over what time range
2. **Pick the right datasource** — use the datasource reference below to match data to source
3. **Write the query** — use the data models and example patterns in this document
4. **Guide the Grafana UI steps** — tell them where to click, which panel type to use, how to set up variables

---

## Grafana UI Guidance

### Creating a New Dashboard
1. Click **"+" → "New dashboard"** in the left sidebar
2. Click **"Add visualization"** to add the first panel
3. Select the appropriate **datasource** from the dropdown at the top of the query editor
4. Write or paste the query
5. Choose a **visualization type** from the top-right dropdown (Time series, Table, Stat, Gauge, Bar chart, etc.)
6. Configure panel title and description in the right sidebar under **"Panel options"**

### Adding Template Variables
1. Go to **Dashboard settings** (gear icon, top right) → **"Variables"**
2. Click **"New variable"**
3. Set **Type** = "Query", pick the datasource, write the query
4. For cascading filters: reference earlier variables with `$variable_name` in later variable queries
5. Common cascade: `Organisation → Room/Bed → Device`

### Common Panel Types by Use Case
| Use case | Panel type | Notes |
|---|---|---|
| Metric over time | **Time series** | Default for most InfluxDB/VictoriaMetrics queries |
| Current value / KPI | **Stat** | Single number with optional sparkline |
| Threshold indicator | **Gauge** | Good for battery %, signal strength |
| Tabular data | **Table** | Best for PostgreSQL overview queries |
| Event log | **Table** | With time column sorted descending |
| Distribution | **Bar chart** | Firmware versions, device counts per org |
| Status map | **State timeline** | Online/offline over time |

### Time Range & Refresh
- Use the **time picker** (top right) to set the dashboard time range
- For live monitoring: set **auto-refresh** (e.g., every 30s or 1m)
- In queries, use Grafana macros like `$__timeFilter(time_column)` (PostgreSQL), `WHERE $timeFilter` (InfluxDB), or `$__timeFrom`/`$__timeTo` (Athena/Timestream)

---

## Datasource Reference

Momo's Grafana has these datasources configured. Each serves a different purpose:

| Datasource name | Type | Database/Bucket | What it contains |
|---|---|---|---|
| **PostgreSQL** | postgres | `momo` | Admin panel operational data — organisations, rooms, users, devices, orders, products, notifications config |
| **InfluxDB Processed** | influxdb | `state_change` | Derived state-change events (online/offline, patient detection, decubitus, restlessness) |
| **InfluxDB** | influxdb | `general_message` | Raw sensor data, device events, WiFi/mesh stats, firmware versions, peripheral state, calibration |
| **InfluxDB - Logs** | influxdb | `logs` | Application-level log metrics (live loop timings, data endpoint stats) |
| **InfluxDB - Metrics** | influxdb | `metrics` | Runtime performance metrics (queue stats, worker stats, request rates) |
| **VictoriaMetrics** | prometheus | — | Real-time sensor digest data (FSR, pressure, angle), container metrics |
| **VictoriaMetrics Long Term Storage** | prometheus | — | Same metrics, longer retention |
| **Timestream** | timestream | `user_events`, `bed_event_logs`, `notification_logs` | User activity (app usage, love credits), bed events, notification delivery logs |
| **Athena Notifications** | athena | `notifications` | Notification entity and action history (DynamoDB export) |
| **Athena Archived Notifications** | athena | `notifications` (S3 Tables) | Long-term archived notification data |
| **Athena SensorData** | athena | `sensor_data` | Long-term archived sensor data (Iceberg tables) |
| **CloudWatch Logs** | cloudwatch | — | Application logs from all backend services |
| **CloudWatch App Backend** | cloudwatch | — | App backend service metrics and logs |
| **CloudWatch Admin Panel Backend** | cloudwatch | — | Admin panel backend metrics and logs |
| **CloudWatch Self Service Backend** | cloudwatch | — | Self-service backend metrics and logs |
| **CloudWatch Integrations** | cloudwatch | — | Integration service metrics (Otiom, API Gateway) |
| **Cloudwatch Notifications** | cloudwatch | — | Notification service custom metrics |
| **Google Sheets** | google-sheets | — | External spreadsheet data |

### Choosing the Right Datasource

| Question | Datasource |
|---|---|
| "How many rooms/users/devices does org X have?" | **PostgreSQL** |
| "Is device X online? What's its signal strength?" | **InfluxDB** or **InfluxDB Processed** |
| "Show me sensor readings for device X" | **VictoriaMetrics** (real-time) or **Athena SensorData** (historical) |
| "How many notifications were sent today?" | **Athena Notifications** or **Cloudwatch Notifications** |
| "How active are users in the app?" | **Timestream** (`user_events`) |
| "What errors are happening in the backend?" | **CloudWatch Logs** |
| "What firmware version is device X running?" | **InfluxDB** (`version` measurement) |
| "Track a specific notification end-to-end" | **Athena Notifications** |
| "Show production assembly stats" | **InfluxDB** (PostFab dashboard) |

---

## Existing Dashboard Landscape

Dashboards are organized by team folder. Understanding what exists helps avoid duplication and shows proven patterns.

### Top-Level (Shared)
- **Home** — Fleet overview: live device count, online ratio, recent notifications, bed counts per org. Mixes InfluxDB + PostgreSQL + VictoriaMetrics + CloudWatch. Uses recursive CTE for org hierarchy.
- **Logs** — Central log viewer across all backend services. CloudWatch Logs with environment/search variables.
- **AuditLogs** — Change audit trail for rooms/beds. PostgreSQL queries on the `audit` table with JSON field extraction.

### Care Teams
- **OrganisationOverview** — Per-org device health: online status, WiFi strength, patient detection, software versions. Heavy InfluxDB + PostgreSQL variable chaining.
- **OnlineDevicesPerOrg** — Online coverage and offline/online transitions. Uses `__expr__` expression panels for derived stats.
- **LoveCreditsOverview** — User engagement scoring. PostgreSQL for org/bed counts + Timestream for activity events.
- **UserActivityByOrganisationLoveCredits** — Deep dive into touch/scroll/notification activity per user. Timestream with time-bucketed CTEs.
- **MismatchedSystem** — Finds bed/sensor/org mismatches. Pure PostgreSQL with multiple mismatch detection queries.
- **TourInfo** — Room tour workflow logs. Timestream + PostgreSQL lookup.
- **RoomTourUserLogs** — Raw room-tour user activity. Timestream.
- **UnusualInactivityPerOrganisation** — Unusual inactivity events per org/device. InfluxDB.

### Connection Team
- **Check-in rondje** — Field ops checklist: inventory, offline devices, battery, coupling, missing stock, mesh/router counts. Very mixed datasources — operational "runbook" dashboard.
- **Check-in rounds** — Planning view: which locations need a check-in based on spare/returned stock imbalance. PostgreSQL CTE aggregation.

### Service & Support
- **Troubleshoot** — Per-device troubleshooting: current bed state + audit log + CloudWatch logs. PostgreSQL + CloudWatch.
- **BatteryCheck** — Peripheral offline/battery status. PostgreSQL + InfluxDB + CloudWatch.
- **BedSenseSoftwareVersions** — Firmware version breakdown by hardware type. InfluxDB.
- **NCSSettings** — Nurse call system settings audit per bed/org. PostgreSQL with JSONB queries.
- **PendantCoverage** — Pendant/device reception coverage. InfluxDB time-bucketed receive counts.
- **Notifications V2 / Troubleshooting: Notifications per Location (V2)** — Notification volume per location. Athena with time-series CTEs.
- **Notifications V2 / Troubleshooting: Track and Trace (V2)** — Notification feature-flag status + recent notifications. PostgreSQL + Athena.
- **Notifications V2 / Troubleshooting: Notification Delay (V2)** — Notification delay analysis. Athena + PostgreSQL.
- **Notifications V2 / (Advanced) Troubleshooting: Notification Actions per Notification Id** — Deep dive into one notification's lifecycle. Athena.

### R&D
- **LiveView** — Live device view: connectivity, versions, MACs, sensor data. PostgreSQL + InfluxDB + VictoriaMetrics.
- **DetailView** — Per-device deep dive: all sensor channels, events, calibration, errors. PostgreSQL + InfluxDB + VictoriaMetrics.
- **LizzyDeviceOverviewPerOrg** — Lizzy device fleet overview. Heavy variable chaining with formatted hardware IDs via `regexp_replace(lpad(...))`.
- **PeripheralStats** — Per-peripheral signal, trigger, battery, activity. InfluxDB + PostgreSQL.
- **MeshStats** — Mesh topology, routing, delays, signal strength. InfluxDB + PostgreSQL. Infers mesh topology from `layer` and `bssid` fields.
- **ButtonView** — Button peripheral details. PostgreSQL + InfluxDB.
- **DoorView** — Door peripheral details. PostgreSQL + InfluxDB.
- **FlutterAppLogging** — Mobile app diagnostics: WiFi, lifecycle, navigation. InfluxDB + Timestream.
- **Offline sensors** — Offline alarms and room/device mapping. CloudWatch Logs.
- **Track & Trace** — Notification delivery tracing. Athena.

### Production
- **PostfabDashboard** — Post-fabrication device checks: router BSSID, hardware type ranges. InfluxDB.
- **RecentlyPressedProduction** — Production button press / door events. InfluxDB with hard-coded device filters.

### Stats
- **AdminPanelStats** — Cumulative totals: bedsenses, orgs, users, sensors, swaps over time. PostgreSQL with window functions.
- **BedSenseIssues** — Offline events, invalid timestamps, uncoupled devices. CloudWatch.
- **BedSenseResponseStats** — Device response/connectivity stats. InfluxDB.
- **DataEndpointMetrics** — Data endpoint performance: request rate, message rate, processing times. InfluxDB metrics.
- **QueueMetrics** — BullMQ queue stats. InfluxDB metrics.
- **LiveLoopMetrics** — Live loop processing timings. InfluxDB logs.
- **System Stats / Cadvisor** — Container resource monitoring: CPU, memory, network, disk. VictoriaMetrics + InfluxDB + CloudWatch.
- **System Stats / SensorApiResponseTimes** — Sensor API performance. InfluxDB + CloudWatch + VictoriaMetrics.

### Other
- **Platform Plumbers / OtiomIncomingEvents** — Otiom event stream. CloudWatch Integrations.
- **Platform Plumbers / APIGatewayStats** — API Gateway and Otiom alarm/latency/error monitoring. CloudWatch Integrations.
- **Explore Team / CloseToExitDebug** — Exit-proximity behavior debug. InfluxDB with `__expr__` derived panels.
- **Customer Champions / AppInsights** — App version distribution by user/device. PostgreSQL.
- **Core / Notifications V2** — Notification service metrics. CloudWatch custom metrics.

### Patterns Worth Reusing
- **Recursive org tree CTE** (Home dashboard) — computes totals across org hierarchy
- **Cascading variables** — `Organisation → Devices → ActiveDevices → ActiveMeshDevices`
- **Formatted hardware IDs** — `regexp_replace(lpad(hardware_id, 8, '0'), '(.{4})', '\1.', 'g')` for copy/paste-friendly display
- **Operational checklist dashboards** — structured like human runbooks, not just observability
- **`__expr__` derived panels** — compute ratios or thresholds from other panel results
- **Mixed-datasource dashboards** — PostgreSQL for entity lookup + InfluxDB/Timestream for time-series in the same dashboard

---

## PostgreSQL Data Model (datasource: "PostgreSQL", database: `momo`)

The admin panel database. Central to most dashboards for entity lookups, configuration, and operational state.

### Core Domain: Organisations & Rooms

#### `organisations`
Care facilities, partners, or internal Momo entities. Central table — almost everything links back here.

| Key columns | Notes |
|---|---|
| `organisation_id` (PK) | Auto-increment |
| `parent_id` → `organisations` | Hierarchical org structure |
| `name`, `full_name` | Short and full display names |
| `type` | `CARE`, `PARTNER`, `INTERNAL`, `ORDER` |
| `state` | Lifecycle: `PLANNED` → `STARTED` → `NOTIFICATIONS` → `EXPERIENCED` → `SCALE_UP` |
| `care_type` | `PG` (psychogeriatric), `SOMATICS`, `ALL` |
| `locale` | `nl`, `en`, `de`, `es` |
| `country_id` → `countries` | Country reference |
| `timezone` | Default `Europe/Amsterdam` |
| `deleted` | Soft delete flag |
| Feature flags | `push_enabled`, `native_genus_enabled`, `support_page_enabled`, `news_page_enabled`, `room_page_enabled`, `allow_genus_video_calls`, `allow_genus_direct_calls`, `asset_tracking_enabled`, `backup_sms_enabled` |
| Privacy/security | `elevated_mfa_enabled`, `login_mfa_enabled`, `privacy_mode_notifications_enabled`, `privacy_mode_override_allowed` |
| Infrastructure | `number_of_routers`, `hub_location`, `hub_exists`, `location_determination` (`ON`/`OFF`) |
| External IDs | `auth0_id`, `hubspot_id` |

#### `rooms` (historically called `beds`)
Individual rooms within a care organisation. Many column names and views still use "bed" terminology.

| Key columns | Notes |
|---|---|
| `room_id` (PK) | |
| `organisation_id` → `organisations` | |
| `room_name` | Display name (e.g. "Room 101") |
| `room_type` | `BEDROOM`, `BATHROOM`, `TOILET`, `HALLWAY`, `LIVING_ROOM`, `NOTIFICATION_STUB` |
| `ward` | Ward/unit grouping |
| `empty`, `empty_reason` | Occupancy status |
| `deleted` | Soft delete |
| Notification settings | `notifications_enabled`, `notifications_delay_s`, `out_bed_danger`, `unusual_inactivity`, `door_notifications`, `motion_notifications`, `proximity_notifications` |
| Privacy mode | `privacy_mode_start`, `privacy_mode_end`, `privacy_mode_valid_till` |
| Decubitus | `decubitus_enabled`, `hour_setting` |

#### `countries`
| `country_id` (PK), `name`, `support_phonenumber`, `use_24_hours_time` |

#### `organisation_internal_settings` / `room_internal_settings`
JSONB `ncs_settings` for nurse call system configuration, 1:1 with org/room.

### Sensors & Devices

#### `bedsenses`
BedSense devices — the core Momo sensor hardware.

| Key columns | Notes |
|---|---|
| `bedsense_id` (PK) | Assigned externally |
| `organisation_id` → `organisations` | |
| `bedsense_type` | `BEDSENSE`, `SITSENSE`, `RANGE_EXTENDER`, `LIZZY` |
| `status` | `NOMINAL`, `ASSEMBLY`, `POST_TO_CARE`, `SPARE`, `DEFECT`, `REPAIR`, `DEAD`, `TRIAGE`, `LOST`, `LOST_INVOICED`, `RETOUR_TO_MOMO`, `PRE_INSTALL`, `IN_STORAGE` |
| `deleted` | Soft delete |

#### `room_bedsenses`
Links BedSense devices to rooms with time ranges. Null `end_at` = currently active.

| `room_bedsense_id` (PK), `room_id` → `rooms`, `bedsense_id`, `start_at`, `end_at`, `deleted`, `new_client` |

#### `sensors`
Non-BedSense sensor hardware (buttons, door sensors, motion sensors, cameras, trackers).

| Key columns | Notes |
|---|---|
| `sensor_id` (PK) | |
| `hardware_id` | Physical device identifier |
| `hardware_type` | `HIK_BUTTON`, `HIK_DOOR`, `HIK_MOTION`, `IC_INCO`, `SITSENSE`, `SB_MOTION`, `GENUS_CARE`, `HIK_WALL_BUTTON`, `HIK_EMERGENCY_BUTTON`, `HIK_ASSET_TRACKER`, `HIK_CLOSE_TO_EXIT_TRACKER`, `SPEAK_LISTEN`, `OTIOM_GPS_TRACKER`, `VISION_INTELLIGENCE_SMART_CAMERA`, `AXIS_LIVESTREAM_CAMERA`, `OTIOM_HOME_BASE`, `OTIOM_EXIT_BASE` |
| `organisation_id` → `organisations` | |
| `status` | Same `part_status_type` enum as bedsenses |

#### `room_sensors`
Links sensors to rooms. Same `start_at`/`end_at` pattern as `room_bedsenses`.

#### `assets` / `asset_sensor`
Trackable physical assets (wheelchairs, lifts). Categories: `WHEEL_CHAIR`, `PASSIVE_LIFT`, `ACTIVE_LIFT`, `KEYCHAIN`, `TRIAGE_BAG`, `SCALE`, `SHOWER_CHAIR`, `STAND_AID`, `ENTERTAINMENT`, `PRESENT`, `OTHER`.

### Users & Authentication

#### `users`
| Key columns | Notes |
|---|---|
| `user_id` (PK) | |
| `username`, `full_name`, `email` | |
| `organisation_id` → `organisations` | |
| `type` | `USER`, `VMS_READONLY`, `VMS_ADMIN`, `USER_MANAGER`, `VMS_POSTFAB`, `VMS_DEVELOPER`, `VMS_SERVICE`, `VMS_BACKUP`, `PVMS_ASSEMBLY`, `PVMS_MAINTAINER`, `PVMS_READONLY`, `PVMS_NON_EU`, `VMS_CONNECTION` |
| `wards` | Array of ward names the user can access |
| `deleted` | Soft delete |
| `auth0_id` | Auth0 identity provider ID |

#### `user_devices`
Mobile devices registered for notifications.

| Key columns | Notes |
|---|---|
| `user_device_id` (PK) | |
| `user_id` → `users` | |
| `device_type` | `Android` or iOS |
| `app_version`, `os_version`, `device_model` | |
| `last_seen` | Last activity |
| `push_token`, `fcm_token` | Notification tokens |

#### `contacts`
Contact persons at care organisations (not necessarily system users). Has `first_name`, `last_name`, `job_function`, `email`, `phone_number`, `project_team`, `unit`.

### Notifications & Events

#### `room_events`
Events detected in rooms (out-of-bed, restlessness, door opened, etc.).

| `room_event_id` (PK), `room_id` → `rooms`, `event_type`, `created_at`, `confirmed_at`, `confirmed_by` → `users` |

#### `room_notifications`
Notifications sent to users about room events.

| `room_notification_id` (PK), `user_id` → `users`, `room_event_id` → `room_events`, `created_at` |

#### `notification_policies`
Configurable notification rules. JSONB `capabilities` and `conditions`. Can be per-room or per-org.

#### `notification_settings` / `notification_windows`
Per-event-type notification config with time windows.

### Products & Inventory

#### `products`
Individual physical product units.

| `product_id` (PK), `product_type_id` → `product_types`, `hardware_id`, `product_location` → `locations` |

#### `product_types`
Product catalog. Categories: `SMARTPHONE`, `ROUTER`, `PACKAGING`, `SENSOR`, `BEDSENSE`, `ACCESSORY`, `OTHER`. Flags: `has_serial_number`, `is_packaging_material`, `legacy`.

#### `locations`
Physical locations where products can be. Types: `STORAGE`, `BROKEN`, `REPAIR`, `R&D`, `CARE`, `LOST`, `LOST_INVOICED`, `TRASH`, `TRIAGE`. Regions: `EUROPE`, `NORTH_AMERICA`. Countries: `NL`, `DE`, `BE`, `CA`, `US`.

#### `product_location_changes` / `nonscannable_product_location_changes`
Audit trail of product movements. Links to `products`, `locations` (source/target), `users`, `orders`, `returns`.

### Orders & Shipping

#### `orders`
| `order_id` (PK), `location_id` → `locations`, `created_at`, `created_by` → `users`, `fulfilled_at`, `fulfilled_by`, `delivery_type` (`TROLLEY`/`POSTNL`/`INTERNATIONAL`/`HANDOVER`/`INTERNATIONAL_PALLET`), `due_date`, `confirmed_by_production`, `is_spare` |

#### `order_items` / `order_users` / `shipments` / `returns`
Line items, assigned users, shipment tracking (`POSTNL`/`DHL` + tracking code), and return records.

### Quality & Repairs

#### `product_issues`
| `product_issue_id` (PK), `product_id` → `products`, `status` (`BROKEN`/`DEAD`/`REPAIRED`), `customer_complaint`, `root_cause` |

#### `repair_actions`
| `repair_action_id` (PK), `product_issue_id`, `user_id`, `category` (`FLASHED_AGAIN`/`REPLACE_CABLE`/`REPLACE_SLEEVE`/`REPLACE_BATTERY`/`HARDWARE_REPAIR`/`OBSERVATION`/`CALIBRATED_AGAIN`) |

#### `problems`
Operational problems (device offline, connectivity issues).

| `problem_id` (PK), `bed_id` → `rooms`, `bedsense_id` → `bedsenses`, `organisation_id`, `cause` (`FAILURE`/`CLIENT_ACTION`/`UNKNOWN`), `status` (`PENDING`/`PROGRESS`/`RESOLVED`), `resolution` (`AUTO`/`CLIENT`/`MOMO`) |

### Other Tables

#### `assembly_data` / `rejects`
Production assembly records and rejected units.

#### `external_apis` / `room_external_apis`
External API integrations (type: `MOMO`, `IQ`) with per-room external ID mapping.

#### `feature_flags` / `feature_flags_organisations` / `feature_flags_users`
Feature flag system with global, per-org, and per-user overrides.

#### `feeds` / `app_updates`
News feed items and app update announcements.

#### `sso_connections` / `sso_location_mappings`
SSO configuration per organisation.

#### `audit`
Change audit log. Columns: `table_name`, `user_name`, `action`, `old_values` (JSONB), `new_values` (JSONB), `diff` (JSONB), `entity_id`.

### Views (backward-compatible "bed" naming)

| View | Maps to | Purpose |
|---|---|---|
| `beds` | `rooms` | Legacy room view |
| `bed_bedsenses` | `room_bedsenses` | Legacy device links |
| `bed_events` | `room_events` | Legacy events |
| `bed_sensors` | `room_sensors` | Legacy sensor links |
| `current_beds` | Joined view | Current room state with attached bedsense and sensors |
| `current_api_beds` | Joined view | Current room state for API consumption |
| `current_bedsenses` | Joined view | Current bedsense state with room info |
| `historic_beds` | Joined view | Historical room-bedsense assignments |

**Note:** Many existing dashboards still use `beds`/`bed_*` view names. Both work, but prefer `rooms`/`room_*` tables for new dashboards.

### Key Relationships

```
organisations (central hub)
  ├── rooms → room_bedsenses → bedsenses
  │         → room_sensors → sensors
  │         → room_events → room_notifications → users
  ├── users → user_devices
  ├── assets → asset_sensor → sensors
  └── products → product_types
               → locations (via product_location)
               → product_location_changes
```

---

## InfluxDB Data Model

Four databases, each serving a different purpose. All use InfluxQL.

### `state_change` (datasource: "InfluxDB Processed")

Derived state-change events. Used for online/offline tracking, patient detection summaries.

#### `bedsense`
Derived state-change summary per device.

| Tags | Fields |
|---|---|
| `device_id` | `button_press`, `decubitus`, `hour_setting`, `online`, `patient_detection`, `posture_change`, `reposition`, `restlessness` |

#### `organisationStats_3m`
Aggregated org-level device stats (computed every 3 minutes).

| Tags | Fields |
|---|---|
| `organisation_id` | `id`, `name`, `full_name`, `device_count`, `active_device_count`, `active_main_device_count`, `active_mesh_device_count`, `missing_device_count`, `missing_main_device_count`, `missing_mesh_device_count` |

### `general_message` (datasource: "InfluxDB")

Raw sensor data and device telemetry. The primary source for device-level dashboards.

#### `sensorData`
Raw sensor arrays from BedSense hardware.

| Tags | Fields |
|---|---|
| `device_id` | `sp_accelero_0..2` (accelerometer), `sp_electric_0..71` (electric sensors), `sp_resistive_0..7` (resistive sensors) |

#### `wifiStats`
WiFi connection status snapshots.

| Tags | Fields |
|---|---|
| `device_id` | `mac` (string), `bssid` (string), `rssi` (int), `time_alive` (bigint) |

#### `meshStats`
Mesh network topology and status.

| Tags | Fields |
|---|---|
| `device_id` | `mac`, `bssid`, `rssi`, `time_alive`, `layer` (int), `parent_id` (int) |

#### `patientDetectState`
Patient detection state changes.

| Tags | Fields |
|---|---|
| `device_id` | `detection` (int), `delay_ms` (int — ingestion delay) |

#### `deviceEvent`
Device event reports.

| Tags | Fields |
|---|---|
| `device_id` | `eventType` (int), `eventText` (string) |

#### `version`
Firmware and hardware version info.

| Tags | Fields |
|---|---|
| `device_id` | `sw_major`, `sw_minor`, `sw_build_number`, `hw_number`, `hw_types` (int) |

`hw_types` values: 150/200 = main board, 220 = mesh board, 240 = BLE board.

#### `calibrationData`
Calibration payload from devices.

| Tags | Fields |
|---|---|
| `device_id` | `calibrated` (int), `scalar_resistive_0..7`, `offset_resistive_0..7`, `scalar_electric_0..5` |

#### `mbedError`
Firmware error reports.

| Tags | Fields |
|---|---|
| `device_id` | `error_code`, `error_module`, `thread_id` (int), `thread_name` (string) |

#### `peripheralStateByBedsenseId`
Peripheral state indexed by parent BedSense.

| Tags | Fields |
|---|---|
| `device_id` | `peripheral_id`, `type`, `software_version`, `rssi`, `voltage_low`, `is_active`, `tamper_triggered`, `detector_triggered`, `consecutive_transmit_fails`, `message_count`, `buffered_count`, `power_level`, `with_ack` |

#### `peripheralStateByPeripheralId`
Same data, indexed by peripheral ID for fast lookup.

| Tags | Fields |
|---|---|
| `peripheral_id` | `device_id`, plus same fields as above |

#### `ppgData`
PPG reference sample data.

| Tags | Fields |
|---|---|
| `device_id` | `ref_ppg_0..3` |

#### `restlessnessState`
Restlessness metrics.

| Tags | Fields |
|---|---|
| `device_id` | `raw`, `level`, `fsr_std_std` (optional) |

#### `percentageStable`
Stability percentage.

| Tags | Fields |
|---|---|
| `device_id` | `percentage_stable` |

### `logs` (datasource: "InfluxDB - Logs")

Application-level timing and performance logs.

#### `liveLoopMetrics`
Live loop processing timings from app-backend.

| Fields |
|---|
| `fullLoopTime`, `sendWsMean`, `sendWsMax`, `sendSioMean`, `sendSioMax`, `fetchRedisMean`, `fetchRedisMax`, `fetchBeds`, `fetchNotifications`, `fetchOrgs`, `fetchUsers` |

### `metrics` (datasource: "InfluxDB - Metrics")

Runtime performance metrics from sensor-api workers.

#### `metrics`
Dynamic metric series. Common fields include:
- `processOtaMessages__AvgPerRequest`, `requestRate`, `messageRate`, `eventRate`
- Queue-specific metrics referenced via `$NewQueues` variable
- Worker stats with tags like `type=worker_stats`, `instance_id=...`

---

## VictoriaMetrics Data Model (datasource: "VictoriaMetrics")

Uses PromQL. Stores real-time sensor digest data and container metrics.

### Sensor Digest Metrics
| Metric pattern | What it is |
|---|---|
| `sensorDigest_fsr_*` | Force-sensitive resistor readings |
| `sensorDigest_pe_std_*` | Piezoelectric standard deviation |
| `sensorDigest_angle` | Angle/posture measurement |
| `sensorOpt_fsr_*` | Optimized FSR readings |
| `sensorOpt_pe_std_*` | Optimized piezoelectric std dev |
| `sensorOpt_pe_raw_(0\|12\|24\|36\|48\|60)` | Raw piezoelectric at specific positions |
| `sensorOpt_angle_2` | Optimized angle measurement |

Common labels: `device_id`.

### Container Metrics
| Metric | What it is |
|---|---|
| `cpu_usage_total_value` | Container CPU usage (label: `container_name`) |

Filter with: `{container_name=~".*momo.*"}`.

---

## Timestream Data Model (datasource: "Timestream")

Three tables, queried with SQL-like Timestream syntax.

### `user_events`
User activity in the mobile app. Primary source for "love credits" and engagement metrics.

| Dimensions (tags) | Measures |
|---|---|
| `organisation_id`, `user_id` | `measure_name` values: `scroll`, `navigation`, `confirm_notification`, `snooze_notification` |

Common query pattern:
```sql
WITH love_credit_5m_per_org_per_user AS (
  SELECT organisation_id, user_id,
         BIN(time, 300s) AS five_min_bucket,
         COUNT(*) AS events
  FROM $__database.$__table
  WHERE measure_name IN ('scroll', 'navigation')
    AND time BETWEEN from_milliseconds($__timeFrom) AND from_milliseconds($__timeTo)
  GROUP BY organisation_id, user_id, BIN(time, 300s)
)
SELECT ...
```

### `bed_event_logs`
Bed/room event logs.

| Dimensions | Measures |
|---|---|
| `organisation_id`, `bed_id`, `event_type`, `created_at` | `notifications_enabled`, `confirmed_at`, `confirmed_by`, `confirmed_by_device` |

### `notification_logs`
Notification delivery logs.

| Dimensions | Measures |
|---|---|
| `organisation_id`, `bed_id`, `event_type`, `created_at`, `user_device_id`, `type` | `repeat_count`, `snooze_count`, `received_at` |

---

## Athena Data Model

### Notifications (datasource: "Athena Notifications")

DynamoDB-exported notification data. Tables: `notification_entity`, `notification_actions`.

#### Querying by room/location
```sql
SELECT timestamp, "eventType", "notificationId"
FROM notifications.notification_entity
WHERE pk = 'roomId=${roomId}#eventType=${eventType}'
  AND sk BETWEEN 'timestamp=${__from:date:iso}' AND 'timestamp=${__to:date:iso}'
ORDER BY sk DESC
```

#### Tracing a specific notification
```sql
SELECT *
FROM notifications.notification_actions
WHERE pk = 'notificationId=${notificationId}'
ORDER BY sk
```

### Archived Notifications (datasource: "Athena Archived Notifications")

Long-term notification archive in S3 Tables (Iceberg). Same logical model, different catalog.

Common pattern — time-bucketed notification counts:
```sql
WITH time_range AS (
  SELECT CAST('${__from:date:iso}' AS timestamp) AS start_time,
         CAST('${__to:date:iso}' AS timestamp) AS end_time
),
time_series AS (
  SELECT date_add('minute', n, start_time) AS bucket_start
  FROM time_range CROSS JOIN UNNEST(sequence(0, ...)) AS t(n)
),
data_prepared AS (
  SELECT date_trunc('minute', timestamp) AS minute_bucket,
         event_type, COUNT(*) AS count
  FROM notifications.notification_entity
  WHERE organisation_id = $organisation_id
    AND state != '4'
    AND timestamp BETWEEN ... AND ...
  GROUP BY 1, 2
)
SELECT ts.bucket_start AS time, dp.event_type, COALESCE(dp.count, 0)
FROM time_series ts LEFT JOIN data_prepared dp ON ts.bucket_start = dp.minute_bucket
```

### Sensor Data (datasource: "Athena SensorData")

Long-term sensor data archive in Iceberg tables under `sensor_data.*`. Tables mirror the InfluxDB measurements:
`calibration_data`, `device_event`, `mesh_stats`, `patient_detect_state`, `mbed_error`, `percentage_stable`, `ppg_data`, `restlessness_state`, `sensor_data`, `version`, `wifi_stats`, `peripheral_state`.

---

## Common Query Patterns for Grafana

### PostgreSQL — Organisation overview with bed counts
```sql
SELECT o.organisation_id, o.name, o.state, o.care_type,
       COUNT(DISTINCT r.room_id) AS room_count
FROM organisations o
LEFT JOIN rooms r ON r.organisation_id = o.organisation_id AND r.deleted = false
WHERE o.deleted = false AND o.type = 'CARE'
GROUP BY o.organisation_id, o.name, o.state, o.care_type
ORDER BY o.name;
```

### PostgreSQL — Recursive org tree (used in Home dashboard)
```sql
WITH RECURSIVE orgs AS (
  SELECT organisation_id, name, parent_id, 0 AS depth
  FROM organisations WHERE parent_id IS NULL AND deleted = false
  UNION ALL
  SELECT o.organisation_id, o.name, o.parent_id, orgs.depth + 1
  FROM organisations o JOIN orgs ON o.parent_id = orgs.organisation_id
  WHERE o.deleted = false
)
SELECT * FROM orgs;
```

### PostgreSQL — Current device assignment for a room
```sql
SELECT rb.room_bedsense_id, b.bedsense_id, b.bedsense_type, b.status
FROM room_bedsenses rb
JOIN bedsenses b ON b.bedsense_id = rb.bedsense_id
WHERE rb.room_id = $bed AND rb.end_at IS NULL AND rb.deleted = false;
```

### PostgreSQL — Audit log with JSON extraction
```sql
SELECT action_timestamp, table_name, user_name, action,
       new_values->>'room_name' AS room_name,
       old_values, new_values, diff
FROM audit
WHERE entity_id = $bed AND table_name = 'rooms'
ORDER BY action_timestamp DESC;
```

### PostgreSQL — Cumulative totals over time (AdminPanelStats pattern)
```sql
SELECT $__timeGroup(created_at, '1d') AS time,
       SUM(COUNT(*)) OVER (ORDER BY $__timeGroup(created_at, '1d')) AS cumulative_total
FROM some_table
WHERE $__timeFilter(created_at)
GROUP BY 1
ORDER BY 1;
```

### PostgreSQL — App version distribution
```sql
SELECT ud.app_version, COUNT(*) AS device_count
FROM user_devices ud
JOIN users u ON u.user_id = ud.user_id
WHERE u.organisation_id = $organisation AND ud.deleted = false
GROUP BY ud.app_version
ORDER BY device_count DESC;
```

### InfluxDB — Device online status
```sql
SELECT last("online") FROM "bedsense"
WHERE ("device_id" =~ /^$DeviceID$/) AND $timeFilter
GROUP BY time($__interval), "device_id" fill(null)
```

### InfluxDB — WiFi signal strength
```sql
SELECT mean("rssi") FROM "wifiStats"
WHERE ("device_id" =~ /^$Devices$/) AND $timeFilter
GROUP BY time($__interval), "device_id" fill(null)
```

### InfluxDB — Firmware version breakdown
```sql
SELECT last("sw_major"), last("sw_minor"), last("sw_build_number"), last("hw_types")
FROM "version"
WHERE ("device_id" =~ /^$Devices$/) AND $timeFilter
GROUP BY "device_id"
```

### InfluxDB — Peripheral battery/offline check
```sql
SELECT last("voltage_low"), last("rssi"), last("is_active")
FROM "peripheralStateByPeripheralId"
WHERE ("peripheral_id" =~ /^$Button$/) AND $timeFilter
GROUP BY time($__interval) fill(null)
```

### VictoriaMetrics — Sensor digest
```
sensorDigest_fsr_0{device_id=~"$DeviceID"}
```

### Timestream — Love credits per org
```sql
WITH love_credit_5m AS (
  SELECT organisation_id,
         BIN(time, 300s) AS bucket,
         COUNT(*) AS events
  FROM $__database.$__table
  WHERE measure_name IN ('scroll', 'navigation')
    AND time BETWEEN from_milliseconds($__timeFrom) AND from_milliseconds($__timeTo)
  GROUP BY organisation_id, BIN(time, 300s)
)
SELECT BIN(bucket, 1d) AS time, organisation_id,
       SUM(CASE WHEN events >= 1 THEN 1 ELSE 0 END) AS love_credits
FROM love_credit_5m
GROUP BY BIN(bucket, 1d), organisation_id
```

---

## Important Notes for Query Writing

1. **Soft deletes everywhere.** Most PostgreSQL tables have a `deleted` boolean. Always filter `WHERE deleted = false` unless you specifically need deleted records.

2. **Rooms vs Beds.** The codebase was renamed from "beds" to "rooms." The `rooms` table PK is `room_id`, but some FK columns still use `bed_id` (e.g., `notification_settings.bed_id` → `rooms.room_id`, `problems.bed_id` → `rooms.room_id`). Views named `bed_*` and `beds` exist for backward compatibility. Existing dashboards use both — either works.

3. **Time-ranged associations.** `room_bedsenses`, `room_sensors`, and `asset_sensor` use `start_at`/`end_at` patterns. A null `end_at` means "currently active."

4. **Grafana macros.** Use `$__timeFilter(column)` for PostgreSQL time filtering, `$timeFilter` for InfluxDB, `from_milliseconds($__timeFrom)` for Timestream, and `${__from:date:iso}` for Athena.

5. **Variable references.** Use `$variable_name` in queries. For InfluxDB regex filters: `=~ /^$DeviceID$/`. For PostgreSQL: `WHERE organisation_id = $organisation`.

6. **Device ID formatting.** BedSense device IDs are integers but often displayed as zero-padded dotted format: `regexp_replace(lpad(hardware_id::text, 8, '0'), '(.{4})', '\1.', 'g')`.

7. **InfluxDB fill strategies.** Use `fill(null)` for gaps in time series, `fill(none)` to skip missing points, `fill(previous)` for step-like data.

8. **JSONB queries.** For NCS settings and audit data, use `->` (JSON object), `->>` (text), `@>` (contains) operators.
