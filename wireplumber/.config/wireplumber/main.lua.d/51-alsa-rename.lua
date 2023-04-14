rule_earhphones = {
    matches = {
        {
            { "node.nick", "equals", "HyperX QuadCast S" },
        },
    },
    apply_properties = {
        ["node.name"] = "Earphones"
    }
}

rule_headphones = {
    matches = {
        {
            { "device.profile.description", "equals", "Front Headphones" },
        },
    },
    apply_properties = {
        ["node.name"] = "Headphones"
    }
}

rule_stereo = {
    matches = {
        {
            { "device.profile.description", "equals", "Speakers" },
        },
    },
    apply_properties = {
        ["node.name"] = "Stereo"
    }
}

table.insert(alsa_monitor.rules, rule_earhphones)
table.insert(alsa_monitor.rules, rule_headphones)
table.insert(alsa_monitor.rules, rule_stereo)
