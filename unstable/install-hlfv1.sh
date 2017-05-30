(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��-Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q�Q��/�c��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�8Yɿ�Y���T��%I���P�wo{�{�l�\�Z��r�K���l��+�r�S�U�/��5��N�;�����q0Ew�~z-�=�h. (J҅�����<��8^���k��P|������E0��pʦ\�Fi�Fi�uH��=�E(�GH�G}�"̵�"]E|¿�>k�U�9ʐ�i�Sċ�/��G����ȗR� �����Nl�jM�>��t��Xk�֩R�.4Q�e$�e���$X`�{+X�R\�ʦ�m�0R�?����_5�
�B ��@���c%�&�'pG���&�OQ4�!
�\gu���=���p:�JH�w��L�	k[�ˋY�E�[�~dK��B]��:uVT�����=п)~i��^4]�~���c������R�Q򿫸:��N���3^��(�cO�?�V��<�����$�ڼ����7�n7�́P֔��'���e�ϚKq�"Zhsa���gݞ�	`ƅ����Y��i1o���h(Ń :yNik�����֍��2ġ�i�:n��L���xYCrf�ԙsu0�O�m�w���q'�ǅ������b<j����)1�C�Aɕ��`!��C.��z�/�-A�(`~��D�MSى�C�;�?W'Nc9xkcŝ4�s�kfQ7�n$m,lq�0�W�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���{B.rp��G�'3�;�A�_�� \�_�[ix⹱� ����"ב.�ˢ�N�rІobd��<�� �-��hӁ����H���Jy`2��E��#�ס��L�Il�@�0�"�l�Qs^?���߰����!���-���&���>d�b��F<g�x��r]�a���l���+����Ϧ���=����������6����>�%�����k�/�
�w�;�ׁzd�7�;u��%�-��=q��%��|�!G�8*�#F��P�1��	���#;� � WS�.�
�{e�ޗ)����u~�e��i(��C�ل��<��.G�މE�r	��b�֐�ek�Dj�b���:w��-��uy�H�\̭���.�� 
@s�e�Rw���=s�mu�4@.�'���	s�0��ax�@����4���Y�@��
�9�W ����&3��r9!��Y��g���n���P��{��oi&�MI!%i㧓F�s��@[�!jCꃙm3�i|����$�E�|����Ś����`�~�n3�'0 ������\ג�p5E�̪9�8L�!����S���w�7��{��$�*��|����y����^���������?���������@q���2�K�������+U�O�����):�I#������8E��_�!h��Ew�e
���E� �h��H�����P��_��~�C�X������vO��M
Zy8�XOP�Yǳ�>Wx�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*��������?U�)�(�t�BW��T���_��W���K�f�O���������C�*���-�gz����C��!|��l����:�f��w�б[��{�Ǯ��|h ���A����p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2iBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��3���������3�*�/��_�������o�����`��?�`���K��
Ϳ���#P���RP��������;����c[ A����+���ؤ�N?�0P>���v�����.�"K�$�"��"B�,J�$I�U���2�y�B�de�����T&��j�R��͉�1]0��cϑV�f?h�CO^��(���0�;uZI��!��h;��e>^�0�m�F9fl������#Bݞ��� ��|�q��g��Rrj��U��������~x
����&���r��/|g�w��PU��rp��o__�.�?N"��/����ۗ/+���O�ť�	�H��t�b��(�T�K��������t��S>e��4B�?��9�m�.cS,���x.����a�G#�n�8K0A��6˰>Zm��2�����?U�?�������Aj�h�(��P�A����0�.���]#M���/���4���v]wW����s)���aDn5f����Q�5#���n��������j=qMP��	ff�^�����_:����+�����1����:�����'��՗FU(e���%ȧ���W��P
^��j�<�{��΁X�qе
�%,�!?��<�}t�gI �����7����*-û���֍��{�.���@7�Gy���D���=�Z�a��=
'���N1��+݅��ΈA??$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�3b��Cb����k�Cba΅�x|�s�[SW�m��Dk�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\�����|t{@�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4���������������2�[��^��>g����r~K�!�W��g�?��J���������6���z��ps'���B�ó�ч���7���3C��o�<���� o=2|rz����k����&>q[��O�A@B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i��z���� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|��)���?BSU�_)�-��Y�Gu��$|���6��9(C�����*��T������_���Q��+���?�a��?�����uw1�cBW񟥠����+��s���������?�ￕ�������1%Q�q(�%\���"��� p���G	�X�
p�G(�����*�o�2�������/���������2%[N��95c����ͩ����-y#��E���x��Ds:n+� �Jx����^�����ط�ܱ
#Jj�9��uG� ?��]K'��@9���C�ި��Q��м:��^x�;��b�GI����h������G���4���������f���Z���2?�N]?�
�j��/��4�C�km�O�t�{a��I��k�1�E\���5re/��}����N�x����&��UM�.�7<�iv��]��w�:��OOL�t�}�ǿh�$���ש�������ֲI�ʭ�����x׵�����[L~��'?ɇ�}��|�����>�9�v��N,���M�jW�i��b����$��׷~���^����Oo�vT�
׾��T4��ng���w��L��fͭ�.����4DU�A�#�Q�����7�������k_�+���
ߎ�}��$w~0������<��0���*�΢г/w�˃����·��śW[���Q��l/����o���:b�]�E��=��e҂H�?m��7����+��z�T��fw���wӻ]��o����������+����O[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k���O4a���"D~��j��Ҿ����}��?��Y<�4�?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n��ŦR��וU��f9�}�axgkxk�p�Y�gK�:�{W�U������\z;u�r;���[tgo��p
�:N�d'q�����q;�{�|WH$�T$`�"� @� �/@��~�VBˇ�Bh�-Z	�;�'�$3�����+�q��|��}����sΙ7t+g&
�����-^�Ŧ�9�`b�˕[r(!a�q(�R���e�||5<��@Wd��s�D�V:KFIhm��1�ɓ���/�e4�"�v��i=0-�@,���M=
D�yM:&��,� �1aZ�;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�ɀ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:��G��;��x��t.?�!h�R:˰�r�;-A�U�|O�B�[�9�&\�f��y��*���4b	�E��?p��m�}|ш_9|�r��xi�Xu�DM�Ԍ[�C�o����h��GS썍��0�u��� mN�����L�:pz68,�)� ��W��?X�i=���:��bg�oj
?�t�ש���G	�y���Q����.�礖����A7�f3i'����	�ӟ��\.7�ˎ(�=��U�E�p?� ede�sKW�5�o��C�<*QAohf�`���\���ՇC�r�.���ǖ/C�*�J�\̔�z��g�>&ׅ�P䦵@٪Fi�:*�n�a� ��,	5:}�%.-��^���:r�h_/����lI�7v�|�s���#�Zj4r�$�Bُۣ%)h��)3�%��t���]fLЊ�-�Y�xڛ�Ń�ht��ܽ�!,�bg�P��d�W�ת�N�.�l��ַ��s�.܁[����1�t�i��M������#�|>y�&�_�:���������������W?�_$�Ӡ�ua���O�������V�O�cuo����CL!>�c�~<Xq/���E<��}��z�G"P�|B|.��>q�����\}{�������=�z����O������ֳ��A�x����|�A��wO�����o�0.�����7��7���_C�p�ܵ��_�x�1,���g�����]i��H7�y����r9��B������� eN��I��di��"�`d��o�1D��=Po�[*�A�Qo"U�ʽ�n	�S���
�RL��ώ9����%�9���B�d�a�N�A3�����f����l3�KVLEr�6g��+Q�*�^� �Ch����l��,�gÓ��yr&�J��[�,Er��h��Z����SJ��k4��#%[��������w�����<N��2�*��2<_��!���3�����CFP�r���%�	�0a&�&LX��'"�~�DX�X���m�	����]��[jFHy �=57BֽzD@)�oĳ-�a���'����~�
�W�fRE�F��]��"�K�`�5�X�)8-�t��S
0�:��ܸ�e�l5�r4R�n,���B�������X�����.J��ah�LF0T��^�(f��(W�1:�	��<�0�d#J-�iY��kE߸/Գ�T��%J-)�Gz��@��b�n���+K���e��ʲ����#Z���d�@��GAo�%�Y�8��b}@�� 't��b�G��y�3�E�Q����m&\J2���u1�P�Fu��gN�,$��E��016Z��òl�+����YR�#��k�%���H�<ĳ�1M}1�vJ�*�zz����E�mV&1KYF�z��?�k�0���u&k�B���z�H��P�(Rzm�%�JY�+�ex��47P�8����{5��Ӵ7�)��#O��i�76څ��G�ZV;dil!=Jj�wP�Ƶj�O����JO5�=��D�tCI�b��CU��1.����-)��ٵ��EvQ�8@��=^oY��K(;��A9�hQ<%����-`p� '�� @��F[��R�JM�X���2_�a��ח.�Z�q��v|6�gs|��|��K��3�8���7��n �B�m݉� [�%����;W�7ϿJۙ|`z��@\P��sy��+�y�*+�SU����0�d3Į�������.���6l�G�J��AUi#��~p)��%err�a� 5�)dE��7���5Wս<#v���i"��\UQm7��jM�1�� ����3�|���3.�6�v�\E�l�	���l�ྰI,�J�f�y+r/��~s���f�LO��̞�r�o_�IM�}1������3�bE���";�����č\ �eEҷ�Ύ��O������˟���o#��}X��R�l�R�܉C�d����� ۡ)�����R�
;���o/���t���Hɬ��梃��dа��{8��`�+G�9��Z,Oc�Ysȃ��{��A��T��c
퍙]�5,�~���4"�+�>΅���j�T'��#X#�A��R*,��%��RċйM7ٴ!T��8\cI��ʑ�=�8֚dL�=!ca)k�ӧ13�%�!{���JD��bz���ן���D�����5
4�J�8�d�b���P�ԒAm��h���|ԇuP���7�F`\l펇#c��B�$�pG��hӋ�n�D }�F�j���R�(�	=�8܎q8���	~���Kzyt*�:�\^6���c2�c�3m��=�G�����s�E.�}ޙ��=���n����1���'�������r"io�Hڦ�Hn.8·*�Z��H]Hs�&��GĒ��|�����b�GkQ�I�`����D�Y�"�V�IPd�Ys�5�+�w��Nok)B�hI9B��Q8�ΐ������0.z��p4����!$��j}mE��둪�GG�a �f+cR4^������Cc!T��_DA��)��+m��hg_�{R�~�Em��_�Y:(W�7&���W252-��Ru�y.�1�|<�rpak{ji����rjO!т�<-�f����i��hVh�إ�7���p����8N��x#~9e�S;e96}m�� ̶s<h��"|�����H����=݊n����ķ�M�V�E��k��{����u�=-�T$ނ�Fd\��I�?p���z呥8��$�<."�;l7�&��]���O^�����c��?�◞��w|���>��� �����VW��|7'-���Ϲ�����������-	�w\_��}�)����.�GF��d�'?������Of�F��E�ߓ�KI��$���4�~�W�rW4&Ӊ5d�����|߻��h�?������Ǒ_|�_?��G~À��W��9j����ˋ��_:�N���P;��Cp���W���W\' ��j�C�t������l�j�����z���Mh�Ap�2C�\���m�����@=�x�9Cg}�������#/�Q^@����9<�S��)��8���k�38G����Af�����٬�93N�ՙ3�Lp�8sf�p��6̙9�|�3L��3sn�w���Mi��.y�ɜ��/�;h�1��$'9�INzݦ��S  