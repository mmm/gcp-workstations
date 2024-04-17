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
  workstation_count = 1
  region            = join("-", slice(split("-", var.zone), 0, 2))
}

resource "google_workstations_workstation_config" "simple" {
  provider               = google-beta
  workstation_config_id  = "simple"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = local.region

  idle_timeout    = "600s"
  running_timeout = "21600s"

  # replica_zones = ["us-central1-a", "us-central1-b"]

  # annotations = {
  #   label-one = "value-one"
  # }

  # labels = {
  #   "label" = "key"
  # }

  host {
    gce_instance {
      machine_type                = "e2-standard-4"
      boot_disk_size_gb           = 35
      disable_public_ip_addresses = true
    }
  }
  container {
    image = "us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest" # this is the default
    # env = {
    #   NAME = "FOO"
    #   BABE = "bar"
    # }
  }
  persistent_directories {
    mount_path = "/home"
    gce_pd {
      size_gb        = 200
      fs_type        = "ext4"
      disk_type      = "pd-standard"
      reclaim_policy = "DELETE"
    }
  }
}

resource "google_workstations_workstation" "simple" {
  count                  = local.workstation_count
  provider               = google-beta
  workstation_id         = "simple-workstation-${count.index}"
  workstation_config_id  = google_workstations_workstation_config.simple.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = local.region

  # env = {
  #   name = "foo"
  # }

  # annotations = {
  #   label-one = "value-one"
  # }

  # labels = {
  #   "label" = "key"
  # }
}
