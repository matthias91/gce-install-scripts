mkdir vpn-data && touch vpn-data/vars
IP_ADDRESS=$(wget -qO- https://ipecho.net/plain)
docker run -v $PWD/vpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$IP_ADDRESS:1194
docker run -v $PWD/vpn-data:/etc/openvpn --rm -it -e EASYRSA_BATCH=1 kylemanna/openvpn ovpn_initpki nopass
docker run -v $PWD/vpn-data:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
sleep 5
docker run -v $PWD/vpn-data:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full user1 nopass
docker run -v $PWD/vpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient user1 > user1.ovpn
cat user1.ovpn