sub vcl_recv {
#FASTLY recv

  if (req.url ~ "^/([^/]+)/([^/]+)") {
    set req.http.networkId = re.group.1;
    set req.http.password = re.group.2;
    set req.url = "";
  }

  if (!req.http.password == "c0cc4a53105a582993deb4f9efc9a368f3f053a34384fb379567e01bfb9aace47") {
    error 401;
  }

  # Select backend based on the networkId

  if (req.http.networkId == "137") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=polygon";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "137_f") {
    set req.backend = F_polygon_am;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "56") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=bsc";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "56_f") {
    set req.backend = F_bsc_serbian;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "250") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=fantom";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "250_f") {
    set req.url = "/ogrpc?network=fantom&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_fantom_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "43114") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=avalanche";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "43114_f") {
    set req.url = "/ogrpc?network=avalanche&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_avalanche_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "42161") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=arbitrum";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "42161_f") {
    set req.url = "/ogrpc?network=arbitrum&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_arbitrum_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1284") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=moonbeam";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1284_f") {
    set req.url = "/ogrpc?network=moonbeam&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_moonbeam_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "81457") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=blast";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "81457_f") {
    set req.url = "/ogrpc?network=blast&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_blast_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "8453") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=base";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "8453_f") {
    set req.url = "/ogrpc?network=base&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_base_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "59144") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=linea";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "59144_f") {
    set req.url = "/ogrpc?network=linea&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_linea_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "324") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=zksync";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "324_f") {
    set req.url = "/ogrpc?network=zksync&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_zksync_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1101") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=polygon-zkevm";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1101_f") {
    set req.url = "/ogrpc?network=polygon-zkevm&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_zkevm_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=ethereum";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1_f") {
    set req.url = "/ogrpc?network=ethereum&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_ethereum_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "25") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=cronos";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "25_f") {
    set req.url = "/ogrpc?network=cronos&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_cronos_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "2222") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=kava";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "2222_f") {
    set req.url = "/ogrpc?network=kava&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_kava_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "169") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=manta-pacific";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "169_f") {
    set req.url = "/ogrpc?network=manta-pacific&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_manta_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "5000") {
    set req.backend = F_rpcman;
    set req.url = "/rpc?key=543798GHWJ759843GFDSJK759843&appId=twap-l3&chain=mantle";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "5000_f") {
    set req.url = "/ogrpc?network=mantle&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_mantle_drpc;
    set req.http.ok = "1";
  }

  if( !req.http.ok ) {
    error 409;
  }

  return(pass);
}

sub vcl_hash {
  set req.hash += req.url;
  set req.hash += req.http.host;
  #FASTLY hash
  return(hash);
}

sub vcl_hit {
#FASTLY hit
  return(deliver);
}

sub vcl_miss {
#FASTLY miss
  return(fetch);
}

sub vcl_pass {
#FASTLY pass
  return(pass);
}

sub vcl_fetch {
#FASTLY fetch

  # Unset headers that reduce cacheability for images processed using the Fastly image optimizer
  if (req.http.X-Fastly-Imageopto-Api) {
    unset beresp.http.Set-Cookie;
    unset beresp.http.Vary;
  }

  # Log the number of restarts for debugging purposes
  if (req.restarts > 0) {
    set beresp.http.Fastly-Restarts = req.restarts;
  }

  # If the response is setting a cookie, make sure it is not cached
  if (beresp.http.Set-Cookie) {
    return(pass);
  }

  # By default we set a TTL based on the `Cache-Control` header but we don't parse additional directives
  # like `private` and `no-store`.  Private in particular should be respected at the edge:
  if (beresp.http.Cache-Control ~ "(private|no-store)") {
    return(pass);
  }

  if( req.method == "OPTIONS" &&  beresp.status == 200 ) {
    set beresp.http.Cache-Control = "max-age=3600, public";
  }

  # If no TTL has been provided in the response headers, set a default
  if (!beresp.http.Expires && !beresp.http.Surrogate-Control ~ "max-age" && !beresp.http.Cache-Control ~ "(s-maxage|max-age)") {
    set beresp.ttl = 0s;

    # Apply a longer default TTL for images processed using Image Optimizer
    if (req.http.X-Fastly-Imageopto-Api) {
      set beresp.ttl = 2592000s; # 30 days
      set beresp.http.Cache-Control = "max-age=2592000, public";
    }
  }

  return(deliver);
}

sub vcl_error {
#FASTLY error
  return(deliver);
}

sub vcl_deliver {
#FASTLY deliver
  return(deliver);
}

sub vcl_log {
#FASTLY log
}
