using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.UI;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using ContosoUniversity.Data;
using ContosoUniversity.Infrastructure;
using ContosoUniversity.Services;

var builder = WebApplication.CreateBuilder(args);

// Add Microsoft Entra ID (Azure AD) authentication
builder.Services.AddMicrosoftIdentityWebAppAuthentication(builder.Configuration, "AzureAd");

// Add services to the container.
builder.Services.AddControllersWithViews(options =>
    {
        // Require authenticated users by default for all controllers
        var policy = new Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .Build();
        options.Filters.Add(new Microsoft.AspNetCore.Mvc.Authorization.AuthorizeFilter(policy));
    })
    .AddNewtonsoftJson()
    .AddMicrosoftIdentityUI();

// Register Razor Pages (required by Microsoft.Identity.Web.UI)
builder.Services.AddRazorPages();

// Register EF Core DbContext
builder.Services.AddDbContext<SchoolContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register application services
builder.Services.AddScoped<NotificationService>();

var app = builder.Build();

// Initialize database
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<SchoolContext>();
    DbInitializer.Initialize(context);
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.MapRazorPages();

app.Run();
