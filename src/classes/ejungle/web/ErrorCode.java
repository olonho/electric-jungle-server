package ejungle.web;

public enum ErrorCode {

    OK,
    CHANGE_SUCCESS,
    LOGON_FAILURE,
    NO_NAME,
    NO_PASSWORD,
    PASSWORD_MISMATCH,
    BAD_PASSWORD,
    DUPLICATE_NAME,
    INTERNAL_ERROR,
    STORAGE_ERROR,
    LIMIT_EXCEEDED,
    INVALID_JAR,
    BAD_BEING_LIST,
    INVALID_PARAMETER,
    SESSION_EXPIRED,
    NO_SUCH_PAGE,
    USER_NOT_FOUND,
    ALREADY_FRIEND,
    INVALID_CHARS,
    TOO_MANY_BEINGS,
    TOO_MANY_CONTESTS,
    SERVER_OVERLOADED,
    INVALID_CAPTCHA,
    DUPLICATED_BEING,
    CURRENTLY_UNAVAILABLE;
    
    public static ErrorCode forName(String name) {
        if (name != null) {
            try {
                return valueOf(name);
            } catch (IllegalArgumentException e) {}
        }
        return null;
    }

}
