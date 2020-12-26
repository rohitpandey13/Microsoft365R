#' OneDrive and Sharepoint Online clients
#'
#' @param tenant For `business_onedrive` and `sharepoint_site`, the name of your Azure Active Directory (AAD) tenant. If not supplied, use the default tenant for your currently logged-in account.
#' @param site_url,site_id For `sharepoint_site`, the web URL and ID of the SharePoint site to retrieve. Supply one or the other, but not both.
#' @details
#' These functions provide easy access to OneDrive and SharePoint in the cloud. Use `personal_onedrive` to access the drive for your personal account, and `business_onedrive` to access the drive for your work or school account. For `business_onedrive` and `sharepoint_site` to work, your organisation must have an appropriate Microsoft 365 license.
#'
#' The default "common" tenant for `business_onedrive` and `sharepoint_site` attempts to detect your actual tenant from your currently logged-in account. This may not always succeed, for example if you have a personal account that is also a guest account in a tenant. In this case, supply the actual tenant name.
#' @return
#' An object of class `ms_drive`.
#' @seealso
#' [ms_drive]
#' @examples
#' \dontrun{
#'
#' personal_onedrive()
#'
#' odb <- business_onedrive("myaadtenant")
#' odb$list_items()
#'
#' site <- sharepoint_site("https://myaadtenant.sharepoint.com/sites/my-site-id")
#' site$get_drive()$list_items()
#'
#' }
#' @rdname client
#' @export
personal_onedrive <- function()
{
    login <- try(get_graph_login("consumers", refresh=FALSE), silent=TRUE)
    if(inherits(login, "try-error"))
        login <- create_graph_login("consumers", app=.azurer_graph_app_id)

    login$get_user()$get_drive()
}

#' @rdname client
#' @export
business_onedrive <- function(tenant="common")
{
    login <- try(get_graph_login(tenant, refresh=FALSE), silent=TRUE)
    if(inherits(login, "try-error"))
        login <- create_graph_login(tenant, app=.az_cli_app_id)

    login$get_user()$get_drive()
}

#' @rdname client
#' @export
sharepoint_site <- function(site_url=NULL, site_id=NULL, tenant="common")
{
    login <- try(get_graph_login(tenant, refresh=FALSE), silent=TRUE)
    if(inherits(login, "try-error"))
        login <- create_graph_login(tenant, app=.az_cli_app_id)

    login$get_sharepoint_site(site_url, site_id)
}