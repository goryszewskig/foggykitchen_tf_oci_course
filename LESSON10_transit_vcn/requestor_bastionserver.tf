resource "oci_core_instance" "FoggyKitchenBastionServer" {
  provider = oci.requestor
  availability_domain = var.ADs1[2]
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = "FoggyKitchenBastionServer"
  shape = var.Shapes[0]
  subnet_id = oci_core_subnet.FoggyKitchenBastionSubnet.id
  source_details {
    source_type = "image"
    source_id   = var.Images1[0]
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
  }
  create_vnic_details {
     subnet_id = oci_core_subnet.FoggyKitchenBastionSubnet.id
     assign_public_ip = true
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenBastionServer_VNIC1_attach" {
  provider = oci.requestor
  availability_domain = var.ADs1[2]
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id = oci_core_instance.FoggyKitchenBastionServer.id
}

data "oci_core_vnic" "FoggyKitchenBastionServer_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenBastionServer_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenBastionServer_PublicIP" {
   value = [data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address]
}
