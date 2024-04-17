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
  region = join("-", slice(split("-", var.zone), 0, 2))
}

data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
    prefix = "terraform/network/state"
  }
}

resource "google_workstations_workstation_cluster" "default" {
  provider               = google-beta
  workstation_cluster_id = "default"
  network                = data.terraform_remote_state.network.outputs.network_id
  subnetwork             = data.terraform_remote_state.network.outputs.subnet_id
  location               = local.region

  # annotations = {
  #   label-one = "value-one"
  # }

  # labels = {
  #   "label" = "key"
  # }
}
