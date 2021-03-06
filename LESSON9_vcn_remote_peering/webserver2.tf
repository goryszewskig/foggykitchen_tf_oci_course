resource "oci_core_instance" "FoggyKitchenWebserver2" {
  provider = oci.requestor
  availability_domain = var.ADs1[1]
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = "FoggyKitchenWebServer2"
  shape = var.Shapes[0]
  subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
  source_details {
    source_type = "image"
    source_id   = var.Images1[0]
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
  }
  create_vnic_details {
     subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
     assign_public_ip = false
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver2_VNIC1_attach" {
  provider = oci.requestor
  availability_domain = var.ADs1[1]
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id = oci_core_instance.FoggyKitchenWebserver2.id
}

data "oci_core_vnic" "FoggyKitchenWebserver2_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver2_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenWebserver2_PrivateIP" {
   value = [data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.private_ip_address]
}
