#!/bin/bash
#spring security oauth2根据code请求用户信息脚本
function getUserInfo(){
	client_id="tdfOauth2SSO213"
	grant_type="authorization_code"
	scope="all"
	client_secret="123456"
	redirect_uri="http%3A%2F%2Flocalhost%3A8888%2Foauth2Callback"
	access_token_uri="http://localhost:9999/oauth/token"
	user_info_uri="http://localhost:9999/me"
	#根据code请求token
	result=`curl --user $client_id:$client_secret \
	$access_token_uri -X POST \
	-H "Content-Type:application/x-www-form-urlencoded" \
	-d "client_id=$client_id&grant_type=$grant_type&scope=$scope&redirect_uri=$redirect_uri&client_secret=$client_secret&code=$1" \
	|grep '\{'`
	echo "result:$result"
	if [[ "$result" =~ "error" ]] #判断result是否包含error
	then
		echo "code:$1 fail"
	else
		echo "code:$1 success"
		access_token=`echo $result |awk -F "," '{print $1}' | awk -F ":" '{print $2}'|sed 's/\"//g'`
		authorization_head="Authorization:bearer $access_token"
		echo "authorization_head:$authorization_head"
		#根据token请求用户信息
		user_info=`curl -H "$authorization_head" -v $user_info_uri`
		echo "user_info:$user_info"
	fi
}
getUserInfo $1