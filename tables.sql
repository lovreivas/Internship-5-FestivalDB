CREATE TABLE festivals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date >= start_date),
    status VARCHAR(20) NOT NULL CHECK (status IN ('planiran','aktivan','zavrsen')),
    has_camp BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE stages (
    id SERIAL PRIMARY KEY,
    festival_id INTEGER NOT NULL REFERENCES festivals(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(50) NOT NULL, 
    max_capacity INTEGER NOT NULL CHECK (max_capacity >= 0),
    covered BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (festival_id, name)
);

CREATE TABLE performers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    genre VARCHAR(50),
    members_count INTEGER DEFAULT 1 CHECK (members_count >= 0),
    active BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE performances (
    id SERIAL PRIMARY KEY,
    festival_id INTEGER NOT NULL REFERENCES festivals(id) ON DELETE CASCADE,
    stage_id INTEGER NOT NULL REFERENCES stages(id) ON DELETE CASCADE,
    performer_id INTEGER NOT NULL REFERENCES performers(id) ON DELETE CASCADE,
    start_ts TIMESTAMP NOT NULL,
    end_ts TIMESTAMP NOT NULL CHECK (end_ts > start_ts),
    expected_attendance INTEGER DEFAULT 0 CHECK (expected_attendance >= 0)
);

CREATE TABLE visitors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    city VARCHAR(50),
    email VARCHAR(254) UNIQUE NOT NULL,
    country VARCHAR(50)
);

CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    festival_id INTEGER NOT NULL REFERENCES festivals(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, 
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    description VARCHAR(500),
    valid_for_entire_festival BOOLEAN NOT NULL DEFAULT FALSE,
    valid_day DATE 
);


CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    visitor_id INTEGER NOT NULL REFERENCES visitors(id) ON DELETE CASCADE,
    festival_id INTEGER NOT NULL REFERENCES festivals(id) ON DELETE CASCADE,
    purchase_ts TIMESTAMP NOT NULL DEFAULT now(),
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0)
);


CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    ticket_id INTEGER NOT NULL REFERENCES tickets(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);


CREATE TABLE workshops (
    id SERIAL PRIMARY KEY,
    festival_id INTEGER NOT NULL REFERENCES festivals(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    level VARCHAR(20) NOT NULL CHECK (level IN ('pocetna','srednja','napredna')),
    max_participants INTEGER NOT NULL CHECK (max_participants >= 1),
    duration_hours NUMERIC(5,2) NOT NULL CHECK (duration_hours > 0),
    requires_prior_knowledge BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TABLE mentors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    expertise_area VARCHAR(100),
    years_experience INTEGER NOT NULL CHECK (years_experience >= 0),
    CONSTRAINT mentor_age CHECK (date_of_birth <= (CURRENT_DATE - INTERVAL '18 years')),
    CONSTRAINT mentor_experience CHECK (years_experience >= 2)
);


CREATE TABLE workshop_mentors (
    workshop_id INTEGER NOT NULL REFERENCES workshops(id) ON DELETE CASCADE,
    mentor_id INTEGER NOT NULL REFERENCES mentors(id) ON DELETE CASCADE,
    PRIMARY KEY (workshop_id, mentor_id)
);


CREATE TABLE workshop_registrations (
    id SERIAL PRIMARY KEY,
    workshop_id INTEGER NOT NULL REFERENCES workshops(id) ON DELETE CASCADE,
    visitor_id INTEGER NOT NULL REFERENCES visitors(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('prijavljen','otkazan','prisustvovao')),
    registered_ts TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE (workshop_id, visitor_id)
);


CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    role VARCHAR(30) NOT NULL, 
    contact VARCHAR(120),
    security_training BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT security_age CHECK (
        role <> 'zastitar' OR date_of_birth <= (CURRENT_DATE - INTERVAL '21 years')
    )
);


CREATE TABLE staff_assignments (
    id SERIAL PRIMARY KEY,
    staff_id INTEGER NOT NULL REFERENCES staff(id) ON DELETE CASCADE,
    festival_id INTEGER NOT NULL REFERENCES festivals(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date >= start_date)
);


CREATE TABLE membership_cards (
    id SERIAL PRIMARY KEY,
    visitor_id INTEGER NOT NULL REFERENCES visitors(id) UNIQUE,
    activation_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('aktivan','istekao'))
);

CREATE INDEX idx_performances_festival ON performances (festival_id);
CREATE INDEX idx_performances_stage ON performances (stage_id);
CREATE INDEX idx_visitors_city ON visitors (city);
CREATE INDEX idx_tickets_festival ON tickets (festival_id);

ALTER TABLE stages
DROP CONSTRAINT stages_festival_id_name_key;

ALTER TABLE workshop_registrations
DROP CONSTRAINT workshop_registrations_workshop_id_visitor_id_key;

ALTER TABLE membership_cards
DROP CONSTRAINT membership_cards_visitor_id_key