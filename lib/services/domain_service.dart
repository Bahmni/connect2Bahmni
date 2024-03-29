import 'package:connect2bahmni/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import '../utils/app_failures.dart';

class DomainService {

  Logger logger = Logger('DomainService');

  Failure handleErrorResponse(Response response) {
    switch(response.statusCode) {
      case 400:
        logger.severe('Server error code - ${response.statusCode}', response.body);
        return Failure(AppConstants.networkError.badRequest, response.statusCode);
      case 401:
        return Failure(AppConstants.networkError.unauthorized, response.statusCode);
      case 403:
        logger.warning('Server error code - ${response.statusCode}', response.body);
        return Failure(AppConstants.networkError.forbidden, response.statusCode);
      case 404:
        logger.severe('Server error code - ${response.statusCode}', response.body);
        return Failure(AppConstants.networkError.notFound, response.statusCode);
      case 406:
        return Failure(AppConstants.networkError.notAcceptable, response.statusCode);
      case 500:
        logger.severe('Server error code - ${response.statusCode}', response.body);
        return Failure(AppConstants.networkError.internalServerError, response.statusCode);
      case 501:
      case 502:
      case 503:
        logger.severe('Server error code - ${response.statusCode}', response.body);
        return Failure(AppConstants.networkError.gatewayError, response.statusCode);
      case 504:
        return Failure(AppConstants.networkError.gatewayTimeout, response.statusCode);
      default:
        return Failure(AppConstants.networkError.unknown, response.statusCode);
    }
  }

}