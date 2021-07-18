
# Creating a Load Balancer

## Creating a Public IP Address

$pubip = @{
    Name = 'sea-lb-ip'
    ResourceGroupName = $RG[0]
    Location = $location[0]
    Sku = 'Standard'
    AllocationMethod = 'static'
}

$lb_pubip = New-AzPublicIpAddress @pubip


## Front End IP

$feip = New-AzLoadBalancerFrontendIpConfig -Name 'LoadBalancerFrontEnd' -PublicIpAddress $lb_pubip


## Creating a Back End Pool

$bepool = New-AzLoadBalancerBackendAddressPoolConfig -Name 'sea-lb-bp'


## Creating a Health Probe

$probehttp = @{
    Name = 'webserver-health'
    Protocol = 'http'
    Port = '80'
    IntervalInSeconds = '360'
    ProbeCount = '5'
    RequestPath = '/'
}
$healthprobe1 = New-AzLoadBalancerProbeConfig @probehttp

$probehttps = @{
    Name = 'webserver-health-s'
    Protocol = 'https'
    Port = '443'
    IntervalInSeconds = '360'
    ProbeCount = '5'
    RequestPath = '/'
}
$healthprobe2 = New-AzLoadBalancerProbeConfig @probehttps


## Creating a Load Balancer Rule

$lbrule1 = @{
    Name = 'Allow_HTTP'
    Protocol = 'tcp'
    FrontendPort = '80'
    BackendPort = '80'
    IdleTimeoutInMinutes = '15'
    FrontendIpConfiguration = $feip
    BackendAddressPool = $bepool
}
$rule_http = New-AzLoadBalancerRuleConfig @lbrule1

$lbrule2 = @{
    Name = 'Allow_HTTPS'
    Protocol = 'tcp'
    FrontendPort = '443'
    BackendPort = '443'
    IdleTimeoutInMinutes = '15'
    FrontendIpConfiguration = $feip
    BackendAddressPool = $bePool
}
$rule_https = New-AzLoadBalancerRuleConfig @lbrule2


## Create the load balancer resource. ##
$loadbalancer = @{
    ResourceGroupName = $RG[0]
    Name = "sea-lb"
    Location = $location[0]
    Sku = 'Standard'
    FrontendIpConfiguration = $feip
    BackendAddressPool = $bePool
    LoadBalancingRule = $rule_http,$rule_https
    Probe = $healthprobe1,$healthprobe2
}

New-AzLoadBalancer @loadbalancer
