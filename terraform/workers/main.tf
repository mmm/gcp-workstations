#
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  worker_count          = 1
  master_os_image       = "debian-cloud/debian-12" #"ubuntu-os-cloud/ubuntu-2204-lts"
  default_instance_type = "n2-standard-4"
}

data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
    prefix = "terraform/network/state"
  }
}

resource "google_compute_instance" "dev" {
  count        = local.worker_count
  name         = "worker-${count.index}"
  machine_type = local.default_instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = local.master_os_image

    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  network_interface {
    network    = data.terraform_remote_state.network.outputs.network_id
    subnetwork = data.terraform_remote_state.network.outputs.subnet_id
    # access_config {} # Ephemeral IP
  }

  # metadata_startup_script = file("provision.sh")
  # metadata_startup_script = templatefile("provision.sh.tmpl", {
  #   home_ip = data.terraform_remote_state.storage.outputs.storage-node-ip-address,
  #   tools_ip = data.terraform_remote_state.storage.outputs.storage-node-ip-address,
  # })
  metadata_startup_script = templatefile("provision.sh.tmpl", { home_ip = "", tools_ip = "" })

  service_account {
    # scopes = ["userinfo-email", "compute-ro", "storage-full"]
    scopes = ["cloud-platform"] # too permissive for production
  }
}
