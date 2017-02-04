. ./bankvar
bash ./crtlog.sh
tmloadcf -y ubbshm
dmloadcf -y dubb.bankapp
tmboot -y
. ./populate.sh

tail -f ULOG.* &
childPID=$!
wait $childPID

