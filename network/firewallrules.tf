resource "google_compute_firewall" "deny-all-ingress" {
  name    = "deny-all-ingress"
  network = google_compute_network.this.name

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["private-subnet"]
  direction     = "INGRESS"
  priority      = 1000

  deny {
    protocol = "all"
  }
}

resource "google_compute_firewall" "allow-iap" {
  name    = "allow-iap"
  network = google_compute_network.this.name

  source_ranges = ["35.235.240.0/20"]  # Google Front Ends (GFEs) for IAP
  target_tags   = ["private-subnet"]
  direction     = "INGRESS"
  priority      = 1002

  allow {
    protocol = "tcp"
    ports    = ["22"]  
  }
}
