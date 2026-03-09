using Microsoft.EntityFrameworkCore;

namespace ContosoUniversity.Data
{
    public static class SchoolContextFactory
    {
        public static SchoolContext Create(string connectionString)
        {
            var optionsBuilder = new DbContextOptionsBuilder<SchoolContext>();
            optionsBuilder.UseSqlServer(connectionString);

            return new SchoolContext(optionsBuilder.Options);
        }
    }
}
