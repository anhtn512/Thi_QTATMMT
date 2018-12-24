apt-get install -y modsecurity-crs
mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i "s|SecRuleEngine DetectionOnly|SecRuleEngine On|" /etc/modsecurity/modsecurity.conf
sed -i "s|SecResponseBodyAccess On|SecResponseBodyAccess Off|" /etc/modsecurity/modsecurity.conf
rm -rf /etc/apache2/mods-enabled/security2.conf
cat > /etc/apache2/mods-enabled/security2.conf <<\EOF
<IfModule security2_module>
        # Default Debian dir for modsecurity's persistent data
        SecDataDir /var/cache/modsecurity

        # Include all the *.conf files in /etc/modsecurity.
        # Keeping your local configuration in that directory
        # will allow for an easy upgrade of THIS file and
        # make your life easier
        IncludeOptional /etc/modsecurity/*.conf
        Include /usr/share/modsecurity-crs/*.conf
        Include /usr/share/modsecurity-crs/activated_rules/*.conf
</IfModule>
EOF
ln -s /usr/share/modsecurity-crs/base_rules/modsecurity_crs_41_sql_injection_attacks.conf /usr/share/modsecurity-crs/activated_rules/
ln -s /usr/share/modsecurity-crs/base_rules/modsecurity_crs_41_xss_attacks.conf /usr/share/modsecurity-crs/activated_rules/