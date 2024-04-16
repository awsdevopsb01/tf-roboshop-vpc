env="dev"
bastion_cidr = ["172.31.42.163/32"]
default_vpc_id = "vpc-0425ed6e297d9e307"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rtb = "rtb-055834df42944e6e3"


vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    subnets = {
      public = {
        name="public"
        cidr_block=["10.0.0.0/24","10.0.1.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
      web = {
        name="web"
        cidr_block=["10.0.2.0/24","10.0.3.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
      app = {
        name="app"
        cidr_block=["10.0.4.0/24","10.0.5.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
      db = {
        name="db"
        cidr_block=["10.0.6.0/24","10.0.7.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
  }
}
}

app = {
  frontend = {
    name = "frontend"
    instance_type="t3.micro"
    subnet_name = "web"
    allow_app_cidr = "public"
    desired_capacity = 2
    max_size = 5
    min_size = 2
  }

  catalogue = {
    name          = "catalogue"
    instance_type ="t3.micro"
    subnet_name   = "app"
    allow_app_cidr = "web"
    desired_capacity = 2
    max_size = 5
    min_size = 2
  }
}

kms_arn = "arn:aws:kms:us-east-1:280878923025:key/1598ad31-8c90-467c-8523-f3a951215606"
docdb = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "4.0.0"
    instance_count = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "2.11.0"
    instance_count = 1
    instance_class = "db.t3.small"
  }
}