pipeline {
  agent {
    label 'linux-docker'
  }

  environment {
    AWS_REGION = 'us-east-1'
    AWS_PROFILE = 'localstack'
    AWS_ENDPOINT_URL = 'http://localhost:4566'
    DOCKER_BUILDKIT = '1' // enable BuildKit
    COMPOSE_DOCKER_CLI_BUILD = '1'
    GRADLE_USER_HOME = "${env.WORKSPACE}/.gradle-cache" // persisted between builds via node workspace retention
    APP_VERSION = "${env.BUILD_NUMBER}"
    TARGET_ENV = 'green'
  }

  options {
    timestamps()
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Prepare Caches') {
      steps {
        sh 'mkdir -p .gradle-cache'
      }
    }

    stage('Terraform Init/Apply') {
      steps {
        dir('terraform') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve -var="active_target_group=blue" -var="environment=blue" -var="app_version=${APP_VERSION}"'
        }
      }
    }

    stage('Build (Gradle, skip tests)') {
      steps {
        sh './gradlew clean build -x test'
      }
    }

    stage('Docker Build & Push (LocalStack)') {
      steps {
        script {
          def ecrRepo = sh(script: 'terraform -chdir=terraform output -raw ecr_repository_url', returnStdout: true).trim()
          sh '''
            aws ecr get-login-password --region ${AWS_REGION} --endpoint-url ${AWS_ENDPOINT_URL} | \
              docker login --username AWS --password-stdin ${ecrRepo}
            docker build -t spring-app:${APP_VERSION} .
            docker tag spring-app:${APP_VERSION} ${ecrRepo}:${APP_VERSION}
            docker tag spring-app:${APP_VERSION} ${ecrRepo}:latest
            docker push ${ecrRepo}:${APP_VERSION}
            docker push ${ecrRepo}:latest
          '''
        }
      }
    }

    stage('Update ECS Service') {
      steps {
        sh '''
          aws ecs update-service \
            --cluster spring-app-cluster \
            --service spring-app-service \
            --force-new-deployment \
            --endpoint-url ${AWS_ENDPOINT_URL}
          aws ecs wait services-stable --cluster spring-app-cluster --services spring-app-service --endpoint-url ${AWS_ENDPOINT_URL}
        '''
      }
    }

    stage('Validate Green via 8080') {
      steps {
        sh '''
          ALB_DNS=$(terraform -chdir=terraform output -raw alb_dns_name)
          curl -sf "http://${ALB_DNS}:8080/health" || (echo "Validation failed" && exit 1)
        '''
      }
    }

    stage('Switch Traffic to Green (modify-listener)') {
      steps {
        sh '''
          LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn $(terraform -chdir=terraform output -raw alb_arn) --endpoint-url ${AWS_ENDPOINT_URL} --query "Listeners[?Port==\`80\`].ListenerArn" --output text)
          TG_GREEN=$(terraform -chdir=terraform output -raw green_target_group_arn)
          aws elbv2 modify-listener --listener-arn "$LISTENER_ARN" --default-actions Type=forward,TargetGroupArn="$TG_GREEN" --endpoint-url ${AWS_ENDPOINT_URL}
        '''
      }
    }
  }

  post {
    always { archiveArtifacts artifacts: 'build/reports/**/*', allowEmptyArchive: true }
  }
}

