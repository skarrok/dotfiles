# sddm executes this file even in wayland

USER_ENV_GENERATOR=/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator

if [ -x $USER_ENV_GENERATOR ]; then
    envs=$($USER_ENV_GENERATOR | xargs)
    systemctl --user set-environment $envs
    export $envs
fi
