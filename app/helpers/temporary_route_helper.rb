module TemporaryRouteHelper

  # FIXME: These helper methods are a temporary measure to allow us to support
  # topics under both the root namespace, and the /topic namespace.  Once
  # everything has been migrated to the /topic namespace, these will no longer
  # be necessary.
  #
  # They mimic the regular Rails routing helpers, and merely deletage to the
  # appripriate real routing helper depending on the incoming request path.

  def topic_path(*args)
    if request_using_namespaced_path?
      namespaced_topic_path(*args)
    else
      non_namespaced_topic_path(*args)
    end
  end

  def subtopic_path(*args)
    if request_using_namespaced_path?
      namespaced_subtopic_path(*args)
    else
      non_namespaced_subtopic_path(*args)
    end
  end

  def latest_changes_path(*args)
    if request_using_namespaced_path?
      namespaced_latest_changes_path(*args)
    else
      non_namespaced_latest_changes_path(*args)
    end
  end

  def email_signup_path(*args)
    if request_using_namespaced_path?
      namespaced_email_signup_path(*args)
    else
      non_namespaced_email_signup_path(*args)
    end
  end

  private

  def request_using_namespaced_path?
    request.path.start_with?("/topic/")
  end
end
