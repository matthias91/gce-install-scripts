INSTANCE_NAME=vpn-instance

echo "Generating $INSTANCE_NAME"

gcloud beta compute --project=enduring-coda-307019 instances create $INSTANCE_NAME --zone=europe-west4-a --machine-type=e2-small --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=867030987021-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=openvpn --image=ubuntu-2004-focal-v20210223 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=$INSTANCE_NAME --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

INSTANCE_IP="`gcloud compute instances list --format=json | jq -r '.[].networkInterfaces[].accessConfigs[].natIP'`"
echo "Sleeping 30 seconds"
sleep 30
ssh -o StrictHostKeyChecking=no $INSTANCE_IP << EOF
 git clone https://github.com/matthias91/gce-install-scripts.git
 sh gce-install-scripts/install-openvpn-ubuntu-20.04-docker.sh
EOF
ssh -o StrictHostKeyChecking=no $INSTANCE_IP << EOF
 sh gce-install-scripts/install-openvpn-ubuntu-20.04-docker-2.sh
EOF
scp -o StrictHostKeyChecking=no $INSTANCE_IP:~/user1.ovpn /mnt/c/Users/Matthias/Desktop/
