// code = 200: Thành công,
// code = 400: Thiếu param mà API yêu cầu phải truyền,
// code = 401: Lỗi xác thực token (là giá trị
// code = 403: Lỗi thiếu validate_token
// code = 404: Lỗi tài khoản không tồn tại.
// code = 409: Lỗi xung đột dữ liệu

const int successCode = 200;
const int failedCode = 400;
const int tokenWrong = 401;
const int missingToken = 403;
const int userNotFound = 404;
const int dataConflicts = 409;