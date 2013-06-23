#!/usr/bin/env bash

_generate_secure_boot_keys() {
	
	for _VAR_ in db KEK PK ; do
		echo
		openssl req -new -x509 -newkey rsa:2048 -subj "/CN=${_VAR_}/" -keyout "${_VAR_}.key" -out "${_VAR_}.crt" -days 3650 -nodes -sha256
		echo
	done
	
}

_sign_binaries() {
	
	mkdir -p /efisys/EFI/tools/efitools
	
	for _INPUT_FILE_ in $(ls -1 /usr/share/efitools/efi/*) ; do
		echo
		sbsign --key db.key --cert db.crt --output "${PWD}/${_INPUT_FILE_}" "${_INPUT_FILE_}"
		sudo cp "${PWD}/${_INPUT_FILE_}" "/efisys/EFI/tools/efitools/${_INPUT_FILE_}"
		echo
	done
	
}

_middle_work() {
	
	for _VAR_ in db KEK PK ; do
		echo
		cert-to-efi-sig-list "${_VAR_}.crt" "${_VAR_}.esl"
		echo
		
		echo
		sign-efi-sig-list -k "${_VAR_}.key" -c "${_VAR_}.crt" "${_VAR_}" "${_VAR_}.esl" "${_VAR_}.auth"
		echo
	done
	
}

_update_vars() {
	
	for _VAR_ in db KEK PK ; do
		echo
		# UpdateVars "${_VAR_}" "${_VAR_}.auth"
		echo
	done
	
}

_generate_secure_boot_keys

_sign_binaries

_middle_work

_update_vars
