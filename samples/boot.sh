. ./bankvar
bash ./crtlog.sh
tmloadcf -y ubbshm
tmboot -y
. ./populate.sh

tail -f ULOG.* &
childPID=$!
wait $childPID

