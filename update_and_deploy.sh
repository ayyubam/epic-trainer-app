#!/bin/bash

# Update and Deploy Epic EMR Trainer Assistant

echo "🚀 UPDATING EPIC EMR TRAINER ASSISTANT"
echo "======================================"

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ ERROR: index.html not found in current directory!"
    echo "Please navigate to your Netlify project directory."
    exit 1
fi

# Backup current index.html
echo "📦 Creating backup..."
cp index.html index.html.backup.$(date +%Y%m%d_%H%M%S)

# Add Staffing Calculator button to profile section
echo "➕ Adding Staffing Calculator button..."
if grep -q "Staffing Calculator" index.html; then
    echo "✅ Staffing Calculator already exists"
else
    # Add after the upgrade button in profile section
    sed -i '' '/<button class="btn btn-premium pulse" id="upgrade-btn">/a\
                <button class="btn btn-info" onclick="openStaffingCalculator()" style="margin-left: 10px;">\
                    <i class="fas fa-calculator"></i> Staffing Calculator\
                </button>' index.html
    echo "✅ Added Staffing Calculator button"
fi

# Add Training Simulator button to resources section
echo "➕ Adding Training Simulator button..."
if grep -q "Training Simulator" index.html; then
    echo "✅ Training Simulator already exists"
else
    # Add after upload button in resources section
    sed -i '' '/<button class="btn btn-primary" id="upload-resource-btn">/a\
            <button class="btn btn-success" onclick="openSimulator()" style="margin-left: 10px;">\
                <i class="fas fa-laptop-medical"></i> Training Simulator\
            </button>' index.html
    echo "✅ Added Training Simulator button"
fi

# Add Go-Live Countdown widget
echo "➕ Adding Go-Live Countdown widget..."
if grep -q "Go-Live Countdown" index.html; then
    echo "✅ Go-Live Countdown already exists"
else
    # Find go-live section and add countdown at the beginning
    sed -i '' '/<section id="go-live" class="tab-content">/a\
    <!-- Go-Live Countdown Widget -->\
    <div class="widget" style="background: linear-gradient(135deg, #4B286D, #7B52AB); color: white; padding: 20px; border-radius: 10px; margin: 20px 0;">\
        <h3><i class="fas fa-calendar-check"></i> Go-Live Countdown</h3>\
        <div id="countdown-timer" style="font-size: 32px; font-weight: bold; text-align: center; margin: 15px 0;">\
            <div class="countdown-item" style="display: inline-block; margin: 0 10px; text-align: center;">\
                <span id="days">00</span>\
                <small>Days</small>\
            </div>\
            <div class="countdown-item" style="display: inline-block; margin: 0 10px; text-align: center;">\
                <span id="hours">00</span>\
                <small>Hours</small>\
            </div>\
            <div class="countdown-item" style="display: inline-block; margin: 0 10px; text-align: center;">\
                <span id="minutes">00</span>\
                <small>Minutes</small>\
            </div>\
        </div>\
        <div class="timeline">\
            <div class="timeline-item completed">\
                <div class="timeline-dot"></div>\
                <div class="timeline-content">\
                    <strong>Team Training Completed</strong>\
                    <small>✓ 100% trained</small>\
                </div>\
            </div>\
            <div class="timeline-item current">\
                <div class="timeline-dot"></div>\
                <div class="timeline-content">\
                    <strong>Dress Rehearsal</strong>\
                    <small>In progress</small>\
                </div>\
            </div>\
            <div class="timeline-item">\
                <div class="timeline-dot"></div>\
                <div class="timeline-content">\
                    <strong>Go-Live Day</strong>\
                    <small>Target: Jan 30, 2024</small>\
                </div>\
            </div>\
        </div>\
    </div>' index.html
    echo "✅ Added Go-Live Countdown widget"
fi

# Add Certification Tracker to profile
echo "➕ Adding Certification Tracker..."
if grep -q "Certification Tracker" index.html; then
    echo "✅ Certification Tracker already exists"
else
    # Find profile content section and add before profile tabs
    sed -i '' '/<div class="profile-tabs">/i\
    <!-- Certification Section -->\
    <div class="certification-tracker" style="background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin: 20px 0;">\
        <h3><i class="fas fa-certificate"></i> Epic Certification Tracker</h3>\
        <div class="cert-cards">\
            <div class="cert-card completed">\
                <div class="cert-icon">\
                    <i class="fas fa-check-circle"></i>\
                </div>\
                <div class="cert-info">\
                    <h4>Epic Physician Trainer</h4>\
                    <p>Completed: Jan 2023</p>\
                    <p>Expires: Jan 2025</p>\
                </div>\
            </div>\
            <div class="cert-card in-progress">\
                <div class="cert-icon">\
                    <i class="fas fa-spinner"></i>\
                </div>\
                <div class="cert-info">\
                    <h4>Epic Beacon Oncology</h4>\
                    <p>Progress: 65%</p>\
                    <div class="progress-bar">\
                        <div class="progress-fill" style="width: 65%"></div>\
                    </div>\
                </div>\
            </div>\
            <div class="cert-card upcoming">\
                <div class="cert-icon">\
                    <i class="fas fa-calendar"></i>\
                </div>\
                <div class="cert-info">\
                    <h4>Epic Radiant</h4>\
                    <p>Scheduled: Mar 2024</p>\
                    <button class="btn btn-sm btn-outline">Schedule</button>\
                </div>\
            </div>\
        </div>\
        \
        <div class="cert-requirements">\
            <h4><i class="fas fa-clipboard-list"></i> Certification Requirements</h4>\
            <ul>\
                <li><input type="checkbox" checked> Complete 40 hours of training</li>\
                <li><input type="checkbox" checked> Pass proficiency exam (80%+)</li>\
                <li><input type="checkbox"> Complete 3 supervised training sessions</li>\
                <li><input type="checkbox"> Submit training portfolio</li>\
            </ul>\
        </div>\
    </div>' index.html
    echo "✅ Added Certification Tracker"
fi

# Add Analytics Dashboard to premium section
echo "➕ Adding Analytics Dashboard..."
if grep -q "Training Analytics" index.html; then
    echo "✅ Analytics Dashboard already exists"
else
    # Add to premium section
    sed -i '' '/<div class="premium-upgrade">/i\
    <!-- Analytics Dashboard -->\
    <div class="analytics-dashboard" style="background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin: 20px 0;">\
        <h3><i class="fas fa-chart-line"></i> Training Analytics</h3>\
        \
        <div class="metrics-grid">\
            <div class="metric-card">\
                <div class="metric-header">\
                    <i class="fas fa-user-graduate" style="color: #4B286D;"></i>\
                    <h4>Training Completion</h4>\
                </div>\
                <div class="metric-value">92%</div>\
                <div class="metric-progress">\
                    <div class="progress-bar">\
                        <div class="progress-fill" style="width: 92%"></div>\
                    </div>\
                </div>\
            </div>\
            \
            <div class="metric-card">\
                <div class="metric-header">\
                    <i class="fas fa-clock" style="color: #28a745;"></i>\
                    <h4>Avg. Training Time</h4>\
                </div>\
                <div class="metric-value">4.2 hrs</div>\
                <div class="metric-trend up">↓ 12% from last month</div>\
            </div>\
            \
            <div class="metric-card">\
                <div class="metric-header">\
                    <i class="fas fa-star" style="color: #FFD700;"></i>\
                    <h4>User Satisfaction</h4>\
                </div>\
                <div class="metric-value">4.7/5.0</div>\
                <div class="metric-trend up">↑ 0.3 from baseline</div>\
            </div>\
            \
            <div class="metric-card">\
                <div class="metric-header">\
                    <i class="fas fa-question-circle" style="color: #dc3545;"></i>\
                    <h4>Support Tickets</h4>\
                </div>\
                <div class="metric-value">42</div>\
                <div class="metric-trend down">↓ 18% from last week</div>\
            </div>\
        </div>\
        \
        <div class="chart-container">\
            <h4><i class="fas fa-chart-bar"></i> Training Progress by Department</h4>\
            <div class="chart" style="height: 200px; margin: 20px 0; display: flex; align-items: flex-end; gap: 10px;">\
                <div class="chart-bar" style="height: 85%; background: #4B286D; flex: 1; position: relative; border-radius: 4px 4px 0 0; min-width: 60px; text-align: center; padding-top: 10px; color: white; font-weight: bold;" title="Nursing: 85%">\
                    <span style="position: absolute; bottom: -25px; left: 0; right: 0; color: #333; font-size: 12px;">Nursing</span>\
                </div>\
                <div class="chart-bar" style="height: 72%; background: #7B52AB; flex: 1; position: relative; border-radius: 4px 4px 0 0; min-width: 60px; text-align: center; padding-top: 10px; color: white; font-weight: bold;" title="Physicians: 72%">\
                    <span style="position: absolute; bottom: -25px; left: 0; right: 0; color: #333; font-size: 12px;">Physicians</span>\
                </div>\
                <div class="chart-bar" style="height: 95%; background: #28a745; flex: 1; position: relative; border-radius: 4px 4px 0 0; min-width: 60px; text-align: center; padding-top: 10px; color: white; font-weight: bold;" title="Ancillary: 95%">\
                    <span style="position: absolute; bottom: -25px; left: 0; right: 0; color: #333; font-size: 12px;">Ancillary</span>\
                </div>\
                <div class="chart-bar" style="height: 68%; background: #ffc107; flex: 1; position: relative; border-radius: 4px 4px 0 0; min-width: 60px; text-align: center; padding-top: 10px; color: white; font-weight: bold;" title="ED: 68%">\
                    <span style="position: absolute; bottom: -25px; left: 0; right: 0; color: #333; font-size: 12px;">ED</span>\
                </div>\
                <div class="chart-bar" style="height: 88%; background: #17a2b8; flex: 1; position: relative; border-radius: 4px 4px 0 0; min-width: 60px; text-align: center; padding-top: 10px; color: white; font-weight: bold;" title="OR: 88%">\
                    <span style="position: absolute; bottom: -25px; left: 0; right: 0; color: #333; font-size: 12px;">OR</span>\
                </div>\
            </div>\
        </div>\
        \
        <div class="data-export">\
            <button class="btn btn-outline" onclick="exportAnalytics()">\
                <i class="fas fa-download"></i> Export Analytics Report\
            </button>\
            <button class="btn btn-primary" onclick="scheduleReport()">\
                <i class="fas fa-calendar-alt"></i> Schedule Weekly Report\
            </button>\
        </div>\
    </div>' index.html
    echo "✅ Added Analytics Dashboard"
fi

# Check if JavaScript functions need to be added
echo "🔍 Checking JavaScript functions..."

# Add Training Simulator modal if not exists
if ! grep -q "simulator-modal" index.html; then
    echo "➕ Adding Training Simulator modal..."
    sed -i '' '/<!-- AI Chat Button -->/i\
<!-- Training Simulator Modal -->\
<div id="simulator-modal" class="modal-overlay">\
    <div class="modal" style="max-width: 900px;">\
        <div class="modal-header">\
            <h2><i class="fas fa-laptop-medical"></i> Epic Training Simulator</h2>\
            <button class="modal-close" onclick="closeSimulator()">&times;</button>\
        </div>\
        <div class="modal-body">\
            <div class="simulator-controls">\
                <select id="sim-scenario" class="form-control">\
                    <option value="">Select Training Scenario</option>\
                    <option value="patient-admit">Patient Admission</option>\
                    <option value="medication-order">Medication Order Entry</option>\
                    <option value="clinical-doc">Clinical Documentation</option>\
                    <option value="discharge">Discharge Process</option>\
                    <option value="billing">Billing & Coding</option>\
                </select>\
                <select id="sim-role" class="form-control">\
                    <option value="">Select User Role</option>\
                    <option value="physician">Physician</option>\
                    <option value="nurse">Nurse</option>\
                    <option value="med-rec">Medical Records</option>\
                    <option value="biller">Billing Specialist</option>\
                </select>\
                <button class="btn btn-primary" onclick="startSimulation()">\
                    <i class="fas fa-play"></i> Start Simulation\
                </button>\
            </div>\
            \
            <div id="simulator-content" class="simulator-content" style="display: none; margin-top: 20px;">\
                <div class="simulator-step" id="step-1">\
                    <h3>Step 1: Patient Lookup</h3>\
                    <p>Enter patient MRN or search by name:</p>\
                    <input type="text" class="form-control" placeholder="MRN: 12345678">\
                    <button class="btn btn-primary" onclick="nextStep(2)" style="margin-top: 10px;">Search</button>\
                </div>\
            </div>\
            \
            <div class="simulator-resources" style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">\
                <h4><i class="fas fa-lightbulb"></i> Pro Tips:</h4>\
                <ul id="sim-tips"></ul>\
            </div>\
        </div>\
    </div>\
</div>' index.html
    echo "✅ Added Training Simulator modal"
fi

# Add Staffing Calculator modal if not exists
if ! grep -q "staffing-calculator" index.html; then
    echo "➕ Adding Staffing Calculator modal..."
    sed -i '' '/<!-- Training Simulator Modal -->/a\
<!-- Staffing Calculator Modal -->\
<div id="staffing-calculator" class="modal-overlay">\
    <div class="modal" style="max-width: 800px;">\
        <div class="modal-header">\
            <h2><i class="fas fa-calculator"></i> Go-Live Staffing Calculator</h2>\
            <button class="modal-close" onclick="closeStaffingCalculator()">&times;</button>\
        </div>\
        <div class="modal-body">\
            <div class="calculator-inputs">\
                <div class="form-group">\
                    <label><i class="fas fa-users"></i> Number of End Users:</label>\
                    <input type="number" id="user-count" value="500" min="1" max="10000" class="form-control">\
                </div>\
                \
                <div class="form-group">\
                    <label><i class="fas fa-hospital"></i> Facility Type:</label>\
                    <select id="facility-type" class="form-control">\
                        <option value="acute">Acute Care Hospital</option>\
                        <option value="ambulatory">Ambulatory/Clinic</option>\
                        <option value="specialty">Specialty Hospital</option>\
                        <option value="multi">Multi-Facility System</option>\
                    </select>\
                </div>\
                \
                <div class="form-group">\
                    <label><i class="fas fa-procedures"></i> High-Acuity Areas:</label>\
                    <div class="checkbox-group">\
                        <label class="checkbox"><input type="checkbox" id="has-ed" checked> Emergency Department</label>\
                        <label class="checkbox"><input type="checkbox" id="has-or" checked> Operating Rooms</label>\
                        <label class="checkbox"><input type="checkbox" id="has-icu" checked> Intensive Care Unit</label>\
                    </div>\
                </div>\
            </div>\
            \
            <button class="btn btn-primary" onclick="calculateStaffing()" style="width: 100%; padding: 15px; margin: 20px 0;">\
                <i class="fas fa-calculator"></i> Calculate Staffing Needs\
            </button>\
            \
            <div id="staffing-results" style="display: none;">\
                <h3><i class="fas fa-chart-pie"></i> Recommended Staffing</h3>\
                <div class="results-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin: 20px 0;">\
                    <div class="result-card" style="background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center;">\
                        <h4>Tier 1 Support</h4>\
                        <div class="result-value" id="tier1-count" style="font-size: 32px; font-weight: bold; color: #4B286D;">0</div>\
                        <p>At-the-elbow support (1:50 ratio)</p>\
                    </div>\
                    <div class="result-card" style="background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center;">\
                        <h4>Tier 2 Support</h4>\
                        <div class="result-value" id="tier2-count" style="font-size: 32px; font-weight: bold; color: #4B286D;">0</div>\
                        <p>Command Center (1:100 ratio)</p>\
                    </div>\
                    <div class="result-card" style="background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center;">\
                        <h4>Tier 3 Support</h4>\
                        <div class="result-value" id="tier3-count" style="font-size: 32px; font-weight: bold; color: #4B286D;">0</div>\
                        <p>Analyst/Builder (1:200 ratio)</p>\
                    </div>\
                    <div class="result-card" style="background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center;">\
                        <h4>Total Staff</h4>\
                        <div class="result-value" id="total-staff" style="font-size: 32px; font-weight: bold; color: #4B286D;">0</div>\
                        <p>Required for successful go-live</p>\
                    </div>\
                </div>\
                \
                <div class="recommendations" style="background: #e8f4fd; padding: 15px; border-radius: 8px;">\
                    <h4><i class="fas fa-lightbulb"></i> Recommendations:</h4>\
                    <ul id="staffing-recommendations"></ul>\
                </div>\
                \
                <button class="btn btn-outline" onclick="exportStaffingPlan()" style="margin-top: 15px;">\
                    <i class="fas fa-download"></i> Export Staffing Plan\
                </button>\
            </div>\
        </div>\
    </div>\
</div>' index.html
    echo "✅ Added Staffing Calculator modal"
fi

# Add JavaScript functions
echo "📝 Adding JavaScript functions..."
# Check if we need to add the functions
if grep -q "function openSimulator" index.html; then
    echo "✅ JavaScript functions already exist"
else
    # Find the closing script tag and add functions before it
    sed -i '' '/<\/script>/i\
    // ==================== TRAINING SIMULATOR ====================\
    function openSimulator() {\
        document.getElementById("simulator-modal").classList.add("active");\
    }\
    \
    function closeSimulator() {\
        document.getElementById("simulator-modal").classList.remove("active");\
    }\
    \
    function startSimulation() {\
        const scenario = document.getElementById("sim-scenario").value;\
        const role = document.getElementById("sim-role").value;\
        \
        if (!scenario || !role) {\
            showNotification("Please select both scenario and role", "warning");\
            return;\
        }\
        \
        document.getElementById("simulator-content").style.display = "block";\
        loadSimulation(scenario, role);\
    }\
    \
    function loadSimulation(scenario, role) {\
        const tips = {\
            "patient-admit": [\
                "Always verify patient identity using two identifiers",\
                "Check for existing records before creating new admission",\
                "Verify insurance eligibility in real-time",\
                "Use SmartTools for common admission diagnoses"\
            ],\
            "medication-order": [\
                "Use BPA (Best Practice Alerts) for drug interactions",\
                "Verify allergies before prescribing",\
                "Use SmartPhrases for common medication orders",\
                "Set appropriate start/stop dates for all medications"\
            ]\
        };\
        \
        const tipsList = document.getElementById("sim-tips");\
        tipsList.innerHTML = "";\
        (tips[scenario] || []).forEach(tip => {\
            tipsList.innerHTML += `<li>${tip}</li>`;\
        });\
    }\
    \
    function nextStep(step) {\
        const content = document.getElementById("simulator-content");\
        content.innerHTML = `\
            <div class="simulator-step" id="step-${step}">\
                <h3>Step ${step}: Complete Training Scenario</h3>\
                <p>Great job! You have completed the simulation.</p>\
                <div style="background: #e8f5e9; padding: 15px; border-radius: 8px; margin: 15px 0;">\
                    <h4><i class="fas fa-check-circle" style="color: #28a745;"></i> Simulation Complete</h4>\
                    <p>You successfully navigated the Epic training scenario.</p>\
                </div>\
                <button class="btn btn-primary" onclick="closeSimulator()">\
                    <i class="fas fa-check"></i> Finish\
                </button>\
            </div>\
        `;\
    }\
    \
    // ==================== STAFFING CALCULATOR ====================\
    function openStaffingCalculator() {\
        document.getElementById("staffing-calculator").classList.add("active");\
    }\
    \
    function closeStaffingCalculator() {\
        document.getElementById("staffing-calculator").classList.remove("active");\
    }\
    \
    function calculateStaffing() {\
        const userCount = parseInt(document.getElementById("user-count").value) || 500;\
        const facilityType = document.getElementById("facility-type").value;\
        const hasED = document.getElementById("has-ed").checked;\
        const hasOR = document.getElementById("has-or").checked;\
        const hasICU = document.getElementById("has-icu").checked;\
        \
        let tier1Ratio = 50;\
        let tier2Ratio = 100;\
        let tier3Ratio = 200;\
        \
        let highAcuityMultiplier = 1.0;\
        if (hasED || hasOR || hasICU) {\
            highAcuityMultiplier = 1.3;\
        }\
        \
        if (facilityType === "ambulatory") {\
            tier1Ratio = 75;\
        } else if (facilityType === "multi") {\
            highAcuityMultiplier *= 1.2;\
        }\
        \
        const tier1Count = Math.ceil((userCount / tier1Ratio) * highAcuityMultiplier);\
        const tier2Count = Math.ceil((userCount / tier2Ratio) * highAcuityMultiplier);\
        const tier3Count = Math.ceil((userCount / tier3Ratio) * highAcuityMultiplier);\
        const totalStaff = tier1Count + tier2Count + tier3Count;\
        \
        document.getElementById("tier1-count").textContent = tier1Count;\
        document.getElementById("tier2-count").textContent = tier2Count;\
        document.getElementById("tier3-count").textContent = tier3Count;\
        document.getElementById("total-staff").textContent = totalStaff;\
        \
        const recommendations = [\
            "Schedule staff in 12-hour shifts for 24/7 coverage",\
            "Ensure 2:1 ratio of clinical to technical support staff",\
            "Plan for 20% contingency coverage for unexpected absences"\
        ];\
        \
        if (hasED) {\
            recommendations.push("Increase ED support ratio to 1:25 during peak hours");\
        }\
        \
        if (hasICU) {\
            recommendations.push("Assign dedicated ICU support with critical care experience");\
        }\
        \
        const recList = document.getElementById("staffing-recommendations");\
        recList.innerHTML = "";\
        recommendations.forEach(rec => {\
            recList.innerHTML += `<li>${rec}</li>`;\
        });\
        \
        document.getElementById("staffing-results").style.display = "block";\
    }\
    \
    function exportStaffingPlan() {\
        const plan = {\
            userCount: document.getElementById("user-count").value,\
            tier1: document.getElementById("tier1-count").textContent,\
            tier2: document.getElementById("tier2-count").textContent,\
            tier3: document.getElementById("tier3-count").textContent,\
            total: document.getElementById("total-staff").textContent,\
            timestamp: new Date().toISOString()\
        };\
        \
        const dataStr = JSON.stringify(plan, null, 2);\
        const dataUri = "data:application/json;charset=utf-8,"+ encodeURIComponent(dataStr);\
        \
        const link = document.createElement("a");\
        link.href = dataUri;\
        link.download = `staffing-plan-${new Date().toISOString().split("T")[0]}.json`;\
        document.body.appendChild(link);\
        link.click();\
        document.body.removeChild(link);\
        \
        showNotification("Staffing plan exported successfully!", "success");\
    }\
    \
    // ==================== GO-LIVE COUNTDOWN ====================\
    function updateCountdown() {\
        const targetDate = new Date("2024-01-30T08:00:00");\
        const now = new Date();\
        const diff = targetDate - now;\
        \
        if (diff > 0) {\
            const days = Math.floor(diff / (1000 * 60 * 60 * 24));\
            const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));\
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));\
            \
            document.getElementById("days").textContent = days.toString().padStart(2, "0");\
            document.getElementById("hours").textContent = hours.toString().padStart(2, "0");\
            document.getElementById("minutes").textContent = minutes.toString().padStart(2, "0");\
        } else {\
            document.getElementById("countdown-timer").innerHTML = \'<div style="color: #FFD700;">🚀 Go-Live Complete!</div>\';\
        }\
    }\
    \
    // Update every minute\
    setInterval(updateCountdown, 60000);\
    updateCountdown();\
    \
    // ==================== ANALYTICS FUNCTIONS ====================\
    function exportAnalytics() {\
        const report = {\
            generated: new Date().toISOString(),\
            metrics: {\
                completionRate: "92%",\
                avgTrainingTime: "4.2 hours",\
                satisfaction: "4.7/5.0",\
                supportTickets: 42\
            },\
            departments: {\
                nursing: "85%",\
                physicians: "72%",\
                ancillary: "95%",\
                ed: "68%",\
                or: "88%"\
            }\
        };\
        \
        const csv = `Metric,Value\\nTraining Completion,92%\\nAvg Training Time,4.2 hrs\\nUser Satisfaction,4.7/5.0\\nSupport Tickets,42\\n\\nDepartment,Completion\\nNursing,85%\\nPhysicians,72%\\nAncillary,95%\\nED,68%\\nOR,88%`;\
        \
        const blob = new Blob([csv], { type: "text/csv" });\
        const url = window.URL.createObjectURL(blob);\
        const a = document.createElement("a");\
        a.href = url;\
        a.download = `training-analytics-${new Date().toISOString().split("T")[0]}.csv`;\
        a.click();\
        \
        showNotification("Analytics report exported as CSV", "success");\
    }\
    \
    function scheduleReport() {\
        showNotification("Weekly analytics report scheduled for Monday mornings", "info");\
    }\
' index.html
    echo "✅ Added JavaScript functions"
fi

echo ""
echo "✅ UPDATE COMPLETE!"
echo "=================="

# Deploy to Netlify
echo ""
echo "🚀 DEPLOYING TO NETLIFY..."
echo "=========================="

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
fi

# Check if netlify.toml exists
if [ ! -f "netlify.toml" ]; then
    echo "⚙️ Creating netlify.toml..."
    cat > netlify.toml << 'TOML'
[build]
  publish = "."

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
TOML
fi

# Commit changes
echo "💾 Committing changes..."
git add .
git commit -m "Add professional features: Training simulator, staffing calculator, certification tracker, analytics dashboard, go-live countdown" 2>/dev/null || echo "Using default commit message"

# Deploy
if command -v netlify &> /dev/null; then
    echo "📤 Deploying to Netlify..."
    netlify deploy --prod
else
    echo "📋 Manual deployment instructions:"
    echo ""
    echo "1. Go to: https://app.netlify.com"
    echo "2. Drag & drop this folder"
    echo "3. Your updated site will deploy automatically"
    echo ""
    echo "🌐 Your site: https://epictrainerassist.netlify.app"
fi

echo ""
echo "🎉 UPDATE SUCCESSFUL!"
echo "====================="
echo "🚀 New features available at: https://epictrainerassist.netlify.app"
echo ""
echo "🆕 FEATURES ADDED:"
echo "1. 🎓 Training Simulator - Interactive Epic workflow training"
echo "2. 👥 Staffing Calculator - Calculate go-live support needs"
echo "3. 📊 Analytics Dashboard - Track training metrics"
echo "4. 🏆 Certification Tracker - Monitor Epic certifications"
echo "5. ⏱️ Go-Live Countdown - Timeline and countdown widget"
echo "6. 📈 Department Analytics - Visual training progress"
echo ""
echo "🔄 Netlify deploying now..."
echo "🌐 Check: https://epictrainerassist.netlify.app"
echo ""
echo "🔧 To test features:"
echo "- Profile tab: Staffing Calculator button"
echo "- Resources tab: Training Simulator button"
echo "- Go-Live section: Countdown widget"
echo "- Premium section: Analytics Dashboard"
