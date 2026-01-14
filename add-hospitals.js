// ==================== COMPLETE US HOSPITAL DATABASE ====================
const usHospitals = [
    // Top 20 Hospitals by US News Ranking
    { id: 101, name: "Mayo Clinic - Rochester", city: "Rochester", state: "MN", beds: 2057, epicVersion: "Epic 2023", specialties: ["Oncology", "Cardiology", "Gastroenterology"] },
    { id: 102, name: "Cleveland Clinic", city: "Cleveland", state: "OH", beds: 5460, epicVersion: "Epic 2023", specialties: ["Cardiology", "Urology", "Orthopedics"] },
    { id: 103, name: "Johns Hopkins Hospital", city: "Baltimore", state: "MD", beds: 1129, epicVersion: "Epic 2023", specialties: ["Neurology", "Psychiatry", "ENT"] },
    { id: 104, name: "Massachusetts General Hospital", city: "Boston", state: "MA", beds: 1057, epicVersion: "Epic 2022", specialties: ["Diabetes", "Endocrinology", "Cancer"] },
    { id: 105, name: "UCSF Medical Center", city: "San Francisco", state: "CA", beds: 785, epicVersion: "Epic 2022", specialties: ["Neurology", "Cancer", "Geriatrics"] },
    { id: 106, name: "UCLA Medical Center", city: "Los Angeles", state: "CA", beds: 485, epicVersion: "Epic 2023", specialties: ["Geriatrics", "Neurology", "Urology"] },
    { id: 107, name: "NewYork-Presbyterian Hospital", city: "New York", state: "NY", beds: 2681, epicVersion: "Epic 2023", specialties: ["Cardiology", "Neurology", "Gastroenterology"] },
    { id: 108, name: "Northwestern Memorial Hospital", city: "Chicago", state: "IL", beds: 897, epicVersion: "Epic 2022", specialties: ["Cardiology", "Neurology", "Orthopedics"] },
    { id: 109, name: "University of Michigan Hospitals", city: "Ann Arbor", state: "MI", beds: 1000, epicVersion: "Epic 2023", specialties: ["Cancer", "Cardiology", "Orthopedics"] },
    { id: 110, name: "Stanford Health Care", city: "Stanford", state: "CA", beds: 613, epicVersion: "Epic 2023", specialties: ["Cancer", "Cardiology", "Neurology"] },
    
    // Additional Major Hospitals by State
    { id: 201, name: "Barnes-Jewish Hospital", city: "St. Louis", state: "MO", beds: 1258, epicVersion: "Epic 2022", specialties: ["Cancer", "Cardiology", "Transplant"] },
    { id: 202, name: "UT Southwestern Medical Center", city: "Dallas", state: "TX", beds: 882, epicVersion: "Epic 2023", specialties: ["Neurology", "Cancer", "Cardiology"] },
    { id: 203, name: "Vanderbilt University Medical Center", city: "Nashville", state: "TN", beds: 1069, epicVersion: "Epic 2023", specialties: ["Cancer", "Cardiology", "Pediatrics"] },
    { id: 204, name: "Duke University Hospital", city: "Durham", state: "NC", beds: 957, epicVersion: "Epic 2023", specialties: ["Cancer", "Cardiology", "Orthopedics"] },
    { id: 205, name: "University of Washington Medical Center", city: "Seattle", state: "WA", beds: 450, epicVersion: "Epic 2022", specialties: ["Cancer", "Rehabilitation", "Transplant"] },
    { id: 206, name: "Brigham and Women's Hospital", city: "Boston", state: "MA", beds: 793, epicVersion: "Epic 2022", specialties: ["Cancer", "Cardiology", "Orthopedics"] },
    { id: 207, name: "Mount Sinai Hospital", city: "New York", state: "NY", beds: 1145, epicVersion: "Epic 2023", specialties: ["Cardiology", "Gastroenterology", "Geriatrics"] },
    { id: 208, name: "Houston Methodist Hospital", city: "Houston", state: "TX", beds: 951, epicVersion: "Epic 2023", specialties: ["Cardiology", "Neurology", "Orthopedics"] },
    { id: 209, name: "Rush University Medical Center", city: "Chicago", state: "IL", beds: 664, epicVersion: "Epic 2022", specialties: ["Orthopedics", "Neurology", "Oncology"] },
    { id: 210, name: "Mayo Clinic - Phoenix", city: "Phoenix", state: "AZ", beds: 268, epicVersion: "Epic 2023", specialties: ["Cancer", "Cardiology", "Transplant"] },
    
    // Children's Hospitals
    { id: 301, name: "Boston Children's Hospital", city: "Boston", state: "MA", beds: 404, epicVersion: "Epic 2023", specialties: ["Pediatric Cardiology", "Pediatric Cancer", "Neonatology"] },
    { id: 302, name: "Children's Hospital of Philadelphia", city: "Philadelphia", state: "PA", beds: 546, epicVersion: "Epic 2022", specialties: ["Pediatric Oncology", "Cardiology", "Neonatology"] },
    { id: 303, name: "Cincinnati Children's Hospital", city: "Cincinnati", state: "OH", beds: 639, epicVersion: "Epic 2023", specialties: ["Pediatric Cancer", "Gastroenterology", "Pulmonology"] },
    { id: 304, name: "Texas Children's Hospital", city: "Houston", state: "TX", beds: 973, epicVersion: "Epic 2023", specialties: ["Pediatric Cardiology", "Cancer", "Transplant"] },
    { id: 305, name: "Children's Hospital Los Angeles", city: "Los Angeles", state: "CA", beds: 390, epicVersion: "Epic 2022", specialties: ["Cancer", "Cardiology", "Neonatology"] },
    
    // VA Hospitals
    { id: 401, name: "VA Greater Los Angeles Healthcare", city: "Los Angeles", state: "CA", beds: 1226, epicVersion: "Epic 2022", specialties: ["Mental Health", "Rehabilitation", "Primary Care"] },
    { id: 402, name: "VA Palo Alto Health Care", city: "Palo Alto", state: "CA", beds: 897, epicVersion: "Epic 2023", specialties: ["Spinal Cord Injury", "Mental Health", "Rehabilitation"] },
    { id: 403, name: "James A. Haley Veterans' Hospital", city: "Tampa", state: "FL", beds: 528, epicVersion: "Epic 2023", specialties: ["Polytrauma", "Spinal Cord Injury", "Rehabilitation"] },
    
    // Additional State Hospitals
    { id: 501, name: "Baptist Health Lexington", city: "Lexington", state: "KY", beds: 383, epicVersion: "Epic 2022", specialties: ["Cardiology", "Orthopedics", "Cancer"] },
    { id: 502, name: "Banner - University Medical Center", city: "Phoenix", state: "AZ", beds: 662, epicVersion: "Epic 2023", specialties: ["Transplant", "Trauma", "Cancer"] },
    { id: 503, name: "Inova Fairfax Hospital", city: "Falls Church", state: "VA", beds: 923, epicVersion: "Epic 2022", specialties: ["Cardiology", "Women's Health", "Cancer"] },
    { id: 504, name: "Scripps Memorial Hospital", city: "La Jolla", state: "CA", beds: 444, epicVersion: "Epic 2023", specialties: ["Cardiology", "Orthopedics", "Cancer"] },
    { id: 505, name: "University of Colorado Hospital", city: "Aurora", state: "CO", beds: 678, epicVersion: "Epic 2023", specialties: ["Cancer", "Transplant", "Trauma"] }
];

// Function to search hospitals
function searchAllHospitals(searchTerm) {
    const term = searchTerm.toLowerCase().trim();
    if (!term) return usHospitals.slice(0, 20); // Return top 20 if no search
    
    return usHospitals.filter(hospital => {
        return hospital.name.toLowerCase().includes(term) ||
               hospital.city.toLowerCase().includes(term) ||
               hospital.state.toLowerCase().includes(term) ||
               hospital.specialties.some(s => s.toLowerCase().includes(term));
    });
}

// Function to display hospital search results
function displayHospitalSearchResults(hospitals) {
    const container = document.getElementById('hospital-list');
    if (!container) return;
    
    container.innerHTML = `
        <div class="search-controls">
            <input type="text" id="hospital-search-input" placeholder="Search by name, city, state, or specialty..." 
                   style="padding: 12px; width: 100%; max-width: 600px; border-radius: 8px; border: 2px solid #4B286D; margin-bottom: 20px;">
            <div class="filter-buttons">
                <button class="filter-btn" data-state="all">All States</button>
                <button class="filter-btn" data-state="CA">California</button>
                <button class="filter-btn" data-state="NY">New York</button>
                <button class="filter-btn" data-state="TX">Texas</button>
                <button class="filter-btn" data-state="FL">Florida</button>
                <button class="filter-btn" data-state="large">Large (500+ beds)</button>
                <button class="filter-btn" data-state="epic2023">Epic 2023</button>
            </div>
        </div>
        <div class="hospital-cards-container" id="hospital-search-results"></div>
    `;
    
    // Add search event listener
    const searchInput = document.getElementById('hospital-search-input');
    searchInput.addEventListener('input', (e) => {
        const results = searchAllHospitals(e.target.value);
        renderHospitalCards(results.slice(0, 50)); // Limit to 50 results
    });
    
    // Add filter button listeners
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const filter = this.dataset.state;
            let filtered = usHospitals;
            
            if (filter === 'large') {
                filtered = usHospitals.filter(h => h.beds >= 500);
            } else if (filter === 'epic2023') {
                filtered = usHospitals.filter(h => h.epicVersion === 'Epic 2023');
            } else if (filter !== 'all') {
                filtered = usHospitals.filter(h => h.state === filter);
            }
            
            renderHospitalCards(filtered.slice(0, 50));
        });
    });
    
    // Initial display
    renderHospitalCards(hospitals.slice(0, 50));
}

// Function to render hospital cards
function renderHospitalCards(hospitals) {
    const container = document.getElementById('hospital-search-results');
    if (!container) return;
    
    container.innerHTML = '';
    
    hospitals.forEach(hospital => {
        const card = document.createElement('div');
        card.className = 'hospital-card';
        card.innerHTML = `
            <h3><i class="fas fa-hospital"></i> ${hospital.name}</h3>
            <div class="hospital-meta">
                <span><i class="fas fa-map-marker-alt"></i> ${hospital.city}, ${hospital.state}</span>
                <span><i class="fas fa-bed"></i> ${hospital.beds} beds</span>
                <span><i class="fas fa-code-branch"></i> ${hospital.epicVersion}</span>
            </div>
            <div class="specialty-list">
                ${hospital.specialties.map(spec => `<span class="specialty-tag">${spec}</span>`).join('')}
            </div>
            <div class="hospital-actions">
                <button class="btn btn-outline save-hospital-btn" data-id="${hospital.id}">
                    <i class="fas fa-bookmark"></i> Save Hospital
                </button>
                <button class="btn btn-primary" onclick="viewHospitalResources(${hospital.id})">
                    <i class="fas fa-folder-open"></i> View Resources
                </button>
            </div>
        `;
        container.appendChild(card);
    });
    
    // Add save button listeners
    document.querySelectorAll('.save-hospital-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const hospitalId = this.dataset.id;
            const hospital = usHospitals.find(h => h.id == hospitalId);
            if (hospital) {
                saveHospitalToProfile(hospital);
                this.innerHTML = '<i class="fas fa-check"></i> Saved';
                this.classList.add('saved');
            }
        });
    });
}

// Function to save hospital to profile
function saveHospitalToProfile(hospital) {
    if (!userState.isPremium) {
        showNotification('Upgrade to Premium to save hospitals', 'warning');
        return;
    }
    
    const savedItem = {
        id: 'hosp-' + hospital.id,
        type: 'hospital',
        title: hospital.name,
        data: hospital,
        savedAt: new Date().toISOString(),
        notes: '',
        category: 'Saved Hospitals'
    };
    
    // Check if already saved
    const existingIndex = userState.savedItems.findIndex(item => item.id === savedItem.id);
    if (existingIndex >= 0) {
        userState.savedItems[existingIndex] = savedItem;
        showNotification('Hospital updated in saved items', 'info');
    } else {
        userState.savedItems.push(savedItem);
        showNotification(hospital.name + ' saved to your profile!', 'success');
    }
    
    saveToStorage();
    updateSavedContentDisplay();
}
