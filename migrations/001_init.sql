CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shows (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  venue VARCHAR(255) NOT NULL,
  starts_at DATETIME NOT NULL,
  INDEX idx_starts (starts_at)
);

CREATE TABLE bookings (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  show_id BIGINT NOT NULL,
  status ENUM('HELD','PAYMENT_PENDING','CONFIRMED','EXPIRED','CANCELLED') NOT NULL,
  seat_count TINYINT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  expires_at DATETIME NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user (user_id, created_at),
  INDEX idx_status_expiry (status, expires_at),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (show_id) REFERENCES shows(id)
);

CREATE TABLE seats (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  show_id BIGINT NOT NULL,
  label VARCHAR(10) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  status ENUM('AVAILABLE','HELD','BOOKED') NOT NULL DEFAULT 'AVAILABLE',
  booking_id BIGINT NULL,
  held_until DATETIME NULL,
  UNIQUE KEY uq_show_label (show_id, label),
  INDEX idx_show_status (show_id, status),
  INDEX idx_booking (booking_id),
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (show_id) REFERENCES shows(id)
);