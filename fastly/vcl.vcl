sub vcl_recv {
#FASTLY recv

  if (req.url ~ "^/([^/]+)/([^/]+)") {
    set req.http.networkId = re.group.1;
    set req.http.password = re.group.2;
    set req.url = "";
  }

  if (!req.http.password == "c0cc4a53105a582993deb4f9efc9a368f3f053a34384fb379567e01bfb9aace47") {
    error 409;
  }

  # Select backend based on the networkId
  if (req.http.networkId == "137") {
    set req.backend = F_polygon_am;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "137_f") {
    set req.url = "/ogrpc?network=polygon&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_polygon_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "56") {
    set req.backend = F_bsc_rpc_56;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "56_f") {
    set req.url = "/ogrpc?network=bsc&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_bsc_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "250_f") {
    set req.url = "/20289f480bd76a6ff8f423a6a395063e";
    set req.backend = F_fantom_chainstack;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "250") {
    set req.url = "/ogrpc?network=fantom&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_fantom_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "43114_f") {
    set req.url = "/02076852eeb79c5e4355b92ef390ec28/ext/bc/C/rpc";
    set req.backend = F_Chainstack_Avax;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "43114") {
    set req.url = "/ogrpc?network=avalanche&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_avalanche_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "42161_f") {
    set req.backend = F_chainstack_arbitrum;
    set req.url = "/52798623f7f93b9e10540aab5d506fec";
    set req.http.ok = "1";
  }

  if (req.http.networkId == "42161") {
    set req.url = "/ogrpc?network=arbitrum&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_arbitrum_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1284_f") {
    set req.url = "/moonbeam";
    set req.backend = F_moonbeam_public;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1284") {
    set req.url = "/ogrpc?network=moonbeam&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_moonbeam_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "81457_f") {
    set req.url = "/blast";
    set req.backend = F_blast_public;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "81457") {
    set req.url = "/ogrpc?network=blast&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_blast_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "8453_f") {
    set req.url = "/7f8ef165dc16c3bd82eb707c839ede42";
    set req.backend = F_Base_chainstack_node;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "8453") {
    set req.url = "/ogrpc?network=base&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_base_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "59144_f") {
    set req.url = "/v3/820cc0e0e43f4f75a2c6f5cef6e0ba0a";
    set req.backend = F_Linea_by_Infura;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "59144") {
    set req.url = "/ogrpc?network=linea&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_linea_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "324_f") {
    set req.url = "/5c2fbc8df3f30059d4d018cf1ca5b7a6";
    set req.backend = F_ZkSync_Chianstack;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "324") {
    set req.url = "/ogrpc?network=zksync&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_zksync_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1101_f") {
    set req.url = "/2fc4f5b6151f0bc82e619390f18a2c53";
    set req.backend = F_ZkEvm_Chainstack;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1101") {
    set req.url = "/ogrpc?network=polygon-zkevm&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_zkevm_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "1_f") {
    set req.url = "/41354d16d1b5c896f474a056be3b8214";
    set req.backend = F_ethereum_chainstack;
    set req.http.ok = "1";
  }
  if (req.http.networkId == "1") {
    set req.url = "/ogrpc?network=ethereum&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_ethereum_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "25_f") {
    set req.url = "/0742ba8eae895d08874afab1768690fb";
    set req.backend = F_cronos_chainstack;
    set req.http.ok = "1";
  }
  if (req.http.networkId == "25") {
    set req.url = "/ogrpc?network=cronos&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_cronos_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "2222_f") {
    set req.url = "/kava_evm";
    set req.backend = F_kava_public;
    set req.http.ok = "1";
  }
  if (req.http.networkId == "2222") {
    set req.url = "/ogrpc?network=kava&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_kava_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "169_f") {
    set req.url = "/http";
    set req.backend = F_manta_public;
    set req.http.ok = "1";
  }
  if (req.http.networkId == "169") {
    set req.url = "/ogrpc?network=manta-pacific&dkey=AsLFV4HL9kVAkLCydcvX4XTQSP-dDeoR75FUivLNMzUy";
    set req.backend = F_manta_drpc;
    set req.http.ok = "1";
  }

  if (req.http.networkId == "5000_f") {
    set req.url = "/mantle";
    set req.backend = F_mantle_public;
    set req.http.ok = "1";
  }
  if (req.http.networkId == "5000") {
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
