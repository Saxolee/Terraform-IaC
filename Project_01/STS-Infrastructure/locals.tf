locals {
    region             = "eu-west-2"
    availability_zones = ["${local.region}a", "${local.region}b", "${local.region}c"]
    tags               = {
        "Environment" : "DEV"
        "Project" : "STS_Cloud_Infrastructure"
    }
}