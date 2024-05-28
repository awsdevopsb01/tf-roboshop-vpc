env="prod"
bastion_cidr = ["172.31.42.163/32"]
monitor_cidr = ["172.31.2.188/32"]
default_vpc_id = "vpc-0425ed6e297d9e307"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rtb = "rtb-055834df42944e6e3"
domain_name = "nldevopsb01.online"
domain_id   = "Z01307132WU1DJMGVKGO6"
kms_arn = "arn:aws:kms:us-east-1:280878923025:key/1598ad31-8c90-467c-8523-f3a951215606"

vpc = {
  main = {
    cidr_block = "10.100.0.0/16"
    subnets = {
      public = {
        name="public"
        cidr_block=["10.100.0.0/24","10.100.1.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
      web = {
        name="web"
        cidr_block=["10.100.2.0/24","10.100.3.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
      app = {
        name="app"
        cidr_block=["10.100.4.0/24","10.100.5.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
      db = {
        name="db"
        cidr_block=["10.100.6.0/24","10.100.7.0/24"]
        azi=["us-east-1a","us-east-1b"]
      }
    }
  }
}

app = {
  frontend = {
    name = "frontend"
    instance_type="t3.small"
    subnet_name = "web"
    allow_app_cidr = "public"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    app_port = 80
    listener_priority = 1
    dns_name = "www"
    lb_type  = "public"
    parameter = []
  }

  catalogue = {
    name          = "catalogue"
    instance_type ="t3.small"
    subnet_name   = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    app_port = 8080
    listener_priority = 1
    lb_type = "private"
    parameter = ["docdb"]
  }

  user = {
    name          = "user"
    instance_type ="t3.small"
    subnet_name   = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    app_port = 8080
    listener_priority = 2
    lb_type = "private"
    parameter = ["docdb"]
  }

  cart = {
    name          = "cart"
    instance_type = "t3.small"
    subnet_name   = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    app_port = 8080
    listener_priority = 3
    lb_type = "private"
    parameter = []
  }

  shipping = {
    name          = "shipping"
    instance_type ="t3.small"
    subnet_name   = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    app_port = 8080
    listener_priority = 4
    lb_type = "private"
    parameter = ["rds"]
  }

  payment = {
    name          = "payment"
    instance_type ="t3.small"
    subnet_name   = "app"
    allow_app_cidr = "app"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    app_port = 8080
    listener_priority = 5
    lb_type = "private"
    parameter = []
  }
}

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
    engine_version = "5.7.mysql_aurora.2.11.5"
    instance_count = 1
    instance_class = "db.t3.large"
  }
}

elasticache = {
  main = {
    subnet_name     = "db"
    allow_db_cidr   = "app"
    engine_version  = "6.x"
    node_type       = "cache.t3.micro"
    num_node_groups = 1
    replicas_per_node_group = 1
  }
}

rabbitmq = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    instance_type = "t3.small"
  }
}

alb = {
  public = {
    name        = "public"
    subnet_name = "public"
    allow_alb_cidr = null
    internal    = false
  }
  private = {
    name        = "private"
    subnet_name = "app"
    allow_alb_cidr = "web"
    internal = true
  }
}