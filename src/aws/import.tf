# Import existing resources
import {
  to = module.vpc.aws_vpc.main
  id = "vpc-0a846616a54b90fca"
}

import {
  to = module.vpc.aws_subnet.public["0"]
  id = "subnet-020a4991460ba7470"
}

import {
  to = module.vpc.aws_subnet.public["1"]
  id = "subnet-017b0710f26ac6aea"
}

import {
  to = module.vpc.aws_subnet.public["2"]
  id = "subnet-06eae40f17bf92738"
}
