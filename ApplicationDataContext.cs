using Microsoft.EntityFrameworkCore;

public class ApplicationDataContext : DbContext
{
    public ApplicationDataContext(
        DbContextOptions<ApplicationDataContext> options
    ) : base(options)
    {

    }

    public DbSet<Customer> Customers { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        base.OnConfiguring(optionsBuilder);
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}