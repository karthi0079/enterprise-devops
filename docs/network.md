# Network Architecture

## VPC

The application runs inside an AWS VPC using the 10.0.0.0/16 CIDR range.

## Public Subnet

The EC2 instance is deployed in a public subnet:

- Subnet CIDR: 10.0.1.0/24
- Public IP assignment: Enabled
- Internet access: Enabled through the Internet Gateway

## Internet Gateway

The VPC is connected to the Internet through an Internet Gateway.

## Route Table

The public subnet uses a route table containing:

- 10.0.0.0/16 → local
- 0.0.0.0/0 → Internet Gateway

## Security Group

The EC2 Security Group allows:

| Protocol | Port | Source |
|---|---:|---|
| TCP | 22 | 0.0.0.0/0 |
| TCP | 80 | 0.0.0.0/0 |

Outbound traffic is allowed.

## Network Flow

Internet
↓
Internet Gateway
↓
Public Subnet
↓
EC2
↓
Docker Application

No NAT Gateway is used because the application server is located in a public subnet.