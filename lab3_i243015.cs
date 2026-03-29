using System.Collections.Specialized;

class Book
{
    private int id;
    private decimal price;
    private int quantity;
    private string isbn;
    public int BookId
    {
        get => id;
        set
        {
            if (value > 0) id = value;
            else Console.WriteLine("ID must be greater than 0");
        }
    }
    public string Title { get; set; }
    public string Author { get; set; }
    public string Genre { get; set; }
    public decimal Price
    {
        get => price;
        set
        {
            if (value > 0) price = value;
            else
            {
                price = 0;
                Console.WriteLine("Value must be greater than 0 ");
            }
        }
    }
    public int Quantity
    {
        get => quantity;
        set
        {
            if (value > 0) quantity = value;
            else
            {
                quantity = 0;
                Console.WriteLine("Quantity must be greater than 0");
            }
        }
    }
    public string ISBN
    {
        get => isbn;
        set
        {
            if (value.Length == 13) isbn = value;
            else Console.WriteLine("ISBN should be 13 digits");
        }
    }
    public decimal CalculateBookTotal()
    {
        return quantity * price;
    }
}
class BookOrder
{
    private Book[] books;
    private int size;
    public BookOrder(int total_books)
    {
        books = new Book[total_books];
        size = 0;
    }
    public void AddBook(Book book)
    {
        for (int i = 0; i < size; i++)
        {
            if (books[i].BookId == book.BookId)
            {
                books[i].Quantity += book.Quantity;
                Console.WriteLine($"\nBook '{book.Title}' quantity updated in cart.");
                return;
            }
        }
        if (size < books.Length)
        {
            books[size++] = book;
            Console.WriteLine($"\nBook '{book.Title}' added to cart successfully.");
        }
        else Console.WriteLine("\nCart is full! Cannot add more books.");
    }
    public void RemoveBook(int id)
    {
        for (int i = 0; i < size; i++)
        {
            if (books[i].BookId == id)
            {
                string removedTitle = books[i].Title;
                for (int j = i; j < size - 1; j++)
                {
                    books[j] = books[j + 1];
                }
                books[size - 1] = null;
                size--;
                Console.WriteLine($"\nBook '{removedTitle}' removed from cart.");
                return;
            }
        }
        Console.WriteLine("\nBook not found in cart.");
    }
    public void UpdateQuantity(int id, int quantity)
    {
        if (quantity <= 0)
        {
            RemoveBook(id);
        }
        else
        {
            bool found = false;
            for (int i = 0; i < size; i++)
            {
                if (books[i].BookId == id)
                {
                    books[i].Quantity = quantity;
                    Console.WriteLine($"\nQuantity updated for Book ID {id}.");
                    found = true;
                    break;
                }
            }
            if (!found)
            {
                Console.WriteLine("\nBook not found in cart.");
            }
        }
    }
    public void ViewCart()
    {
        if (size == 0)
        {
            Console.WriteLine("\nYour cart is empty.");
            return;
        }

        Console.WriteLine("\n" + new string('=', 80));
        Console.WriteLine("YOUR CART");
        Console.WriteLine(new string('=', 80));

        for (int i = 0; i < size; i++)
        {
            Book temp = books[i];
            Console.WriteLine($"\nBook #{i + 1}:");
            Console.WriteLine($"  Book ID: {temp.BookId}");
            Console.WriteLine($"  Title: {temp.Title}");
            Console.WriteLine($"  Author: {temp.Author}");
            Console.WriteLine($"  Genre: {temp.Genre}");
            Console.WriteLine($"  Price: ${temp.Price:F2}");
            Console.WriteLine($"  Quantity: {temp.Quantity}");
            Console.WriteLine($"  ISBN: {temp.ISBN}");
            Console.WriteLine($"  Book Total: ${temp.CalculateBookTotal():F2}");
        }
        Console.WriteLine(new string('=', 80));
    }
    public decimal CalculateSubtotal()
    {
        decimal subtotal = 0;
        for (int i = 0; i < size; i++)
        {
            subtotal += books[i].CalculateBookTotal();
        }
        return subtotal;
    }
    public decimal ApplyMemberDiscount(string memberType)
    {
        decimal subtotal = CalculateSubtotal();
        decimal discount = 0;
        switch (memberType)
        {
            case "Platinum":
                discount = subtotal * 0.15m;
                break;
            case "Gold":
                discount = subtotal * 0.10m;
                break;
            case "Silver":
                discount = subtotal * 0.05m;
                break;
            default:
                discount = 0;
                break;
        }
        return subtotal - discount;
    }
    public int CalculateShippingTotal(string memberType)
    {
        decimal subtotal = ApplyMemberDiscount(memberType);
        int shippingFee = 0;
        if (subtotal < 2000)
        {
            shippingFee = 150;
        }
        return shippingFee;
    }
    public decimal GetDiscountAmount(string memberType)
    {
        decimal subtotal = CalculateSubtotal();
        decimal discount = 0;
        switch (memberType)
        {
            case "Platinum":
                discount = subtotal * 0.15m;
                break;
            case "Gold":
                discount = subtotal * 0.10m;
                break;
            case "Silver":
                discount = subtotal * 0.05m;
                break;
            default:
                discount = 0;
                break;
        }
        return discount;
    }
    public decimal CalculateFinalTotal(string memberType)
    {
        decimal subtotalAfterDiscount = ApplyMemberDiscount(memberType);
        int shippingFee = CalculateShippingTotal(memberType);
        return subtotalAfterDiscount + shippingFee;
    }
    public void DisplayFinalBill(string memberType)
    {
        if (size == 0)
        {
            Console.WriteLine("\nYour cart is empty. No bill to display.");
            return;
        }

        decimal subtotal = CalculateSubtotal();
        decimal discountAmount = GetDiscountAmount(memberType);
        decimal subtotalAfterDiscount = ApplyMemberDiscount(memberType);
        int shippingFee = CalculateShippingTotal(memberType);
        decimal finalTotal = CalculateFinalTotal(memberType);

        Console.WriteLine("\n" + new string('=', 80));
        Console.WriteLine("FINAL BILL");
        Console.WriteLine(new string('=', 80));
        Console.WriteLine($"Membership Level: {(string.IsNullOrEmpty(memberType) ? "None" : memberType)}");
        Console.WriteLine(new string('-', 80));
        Console.WriteLine($"Subtotal:                               ${subtotal,12:F2}");
        if (discountAmount > 0)
        {
            Console.WriteLine($"Membership Discount:                   -${discountAmount,12:F2}");
            Console.WriteLine($"Subtotal After Discount:                ${subtotalAfterDiscount,12:F2}");
        }
        Console.WriteLine($"Shipping Fee:                           ${shippingFee,12:F2}");
        Console.WriteLine(new string('-', 80));
        Console.WriteLine($"FINAL TOTAL:                            ${finalTotal,12:F2}");
        Console.WriteLine(new string('=', 80));
    }
}
class Program
{
    static void Main(string[] args)
    {
        BookOrder order = new BookOrder(20);
        string memberType = "";
        bool exitProgram = false;


        while (!exitProgram)
        {
            Console.WriteLine("1. Add Book to Cart");
            Console.WriteLine("2. Remove Book from Cart");
            Console.WriteLine("3. Update Book Quantity");
            Console.WriteLine("4. View Cart Contents");
            Console.WriteLine("5. Set Membership Level");
            Console.WriteLine("6. Display Final Bill");
            Console.WriteLine("7. Exit");
            Console.Write("Enter your choice (1-7): ");

            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    AddBookToCart(order);
                    break;
                case "2":
                    RemoveBookFromCart(order);
                    break;
                case "3":
                    UpdateBookQuantity(order);
                    break;
                case "4":
                    order.ViewCart();
                    break;
                case "5":
                    memberType = SetMembershipLevel();
                    break;
                case "6":
                    order.DisplayFinalBill(memberType);
                    break;
                case "7":
                    exitProgram = true;
                    Console.WriteLine("\nThank you for visiting our bookstore! Goodbye!");
                    break;
                default:
                    Console.WriteLine("\nInvalid choice! Please enter a number between 1 and 7.");
                    break;
            }
        }
    }

    static void AddBookToCart(BookOrder order)
    {
        Console.WriteLine("\n--- Add Book to Cart ---");

        try
        {
            Console.Write("Enter Book ID: ");
            int bookId = int.Parse(Console.ReadLine());

            Console.Write("Enter Title: ");
            string title = Console.ReadLine();

            Console.Write("Enter Author: ");
            string author = Console.ReadLine();

            Console.Write("Enter Genre: ");
            string genre = Console.ReadLine();

            Console.Write("Enter Price: ");
            decimal price = decimal.Parse(Console.ReadLine());

            Console.Write("Enter Quantity: ");
            int quantity = int.Parse(Console.ReadLine());

            Console.Write("Enter ISBN (13 digits): ");
            string isbn = Console.ReadLine();

            Book book = new Book
            {
                BookId = bookId,
                Title = title,
                Author = author,
                Genre = genre,
                Price = price,
                Quantity = quantity,
                ISBN = isbn
            };

            order.AddBook(book);
        }
        catch (FormatException)
        {
            Console.WriteLine("\nInvalid input! Please enter valid data.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"\nAn error occurred: {ex.Message}");
        }
    }

    static void RemoveBookFromCart(BookOrder order)
    {
        Console.WriteLine("\n--- Remove Book from Cart ---");

        try
        {
            Console.Write("Enter Book ID to remove: ");
            int bookId = int.Parse(Console.ReadLine());
            order.RemoveBook(bookId);
        }
        catch (FormatException)
        {
            Console.WriteLine("\nInvalid input! Please enter a valid Book ID.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"\nAn error occurred: {ex.Message}");
        }
    }

    static void UpdateBookQuantity(BookOrder order)
    {
        Console.WriteLine("\n--- Update Book Quantity ---");

        try
        {
            Console.Write("Enter Book ID: ");
            int bookId = int.Parse(Console.ReadLine());

            Console.Write("Enter New Quantity (0 to remove): ");
            int quantity = int.Parse(Console.ReadLine());

            order.UpdateQuantity(bookId, quantity);
        }
        catch (FormatException)
        {
            Console.WriteLine("\nInvalid input! Please enter valid numbers.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"\nAn error occurred: {ex.Message}");
        }
    }

    static string SetMembershipLevel()
    {
        Console.WriteLine("\n--- Set Membership Level ---");
        Console.WriteLine("Available Membership Levels:");
        Console.WriteLine("1. Platinum (15% discount)");
        Console.WriteLine("2. Gold (10% discount)");
        Console.WriteLine("3. Silver (5% discount)");
        Console.WriteLine("4. None (No discount)");
        Console.Write("Enter your choice (1-4): ");

        string choice = Console.ReadLine();
        string memberType = "";

        switch (choice)
        {
            case "1":
                memberType = "Platinum";
                Console.WriteLine("\nMembership level set to: Platinum (15% discount)");
                break;
            case "2":
                memberType = "Gold";
                Console.WriteLine("\nMembership level set to: Gold (10% discount)");
                break;
            case "3":
                memberType = "Silver";
                Console.WriteLine("\nMembership level set to: Silver (5% discount)");
                break;
            case "4":
                memberType = "";
                Console.WriteLine("\nMembership level set to: None");
                break;
            default:
                Console.WriteLine("\nInvalid choice! Membership set to: None");
                memberType = "";
                break;
        }

        return memberType;
    }
}