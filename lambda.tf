##################################################################################
# DATA
##################################################################################

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_lambda_layer_version" "converter-lambda-layer" {
  count = var.lambda_layer_count

  filename   = "./assets/lambda-layers/${var.lambda_layer_name[count.index]}/bin.zip"
  layer_name = "${var.pName}-${var.lambda_layer_name[count.index]}-layer"

  compatible_runtimes      = ["nodejs14.x"]
  compatible_architectures = ["x86_64"]
}

resource "aws_lambda_function" "qb-file-converter" {
  filename      = "./assets/lambda-functions/file-converter.zip"
  function_name = "qb-file-converter"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  role          = data.aws_iam_role.labrole.arn
  layers        = aws_lambda_layer_version.converter-lambda-layer[*].arn
  timeout       = 120
  memory_size   = 512

  environment {
    variables = {
      BUCKET_NAME = "qb-test-test"
    }
  }

  tags = {
    "Name" = "${var.pName}-file-converter"
  }
}
