using System;
using System.Collections.Specialized;

public class Room
{
    public int id { get; set; }
    public string Type { get; set; }  // Simple property now
    public decimal Price { get; set; }
    public int Nights { get; set; }
    public string guestname { get; set; }
    public string CheckInDate { get; set; }
    public string CheckoutDate { get; set; }
    public bool IsAC { get; set; }
    public string MealPlan { get; set; }  // Simple property now

    public decimal calculateroomcost()
    {
        return Price * Nights;
    }
}

public class hotelbooking
{
    int numberofrooms;
    int currentbookings = 0;
    public Room[] rooms;

    public hotelbooking(int numberofrooms)
    {
        this.numberofrooms = numberofrooms;
        rooms = new Room[numberofrooms];
    }

    public void BookRoom(Room room)
    {
        // Expand array if needed
        if (currentbookings >= numberofrooms)
        {
            numberofrooms *= 2;
            Array.Resize(ref rooms, numberofrooms);
        }

        // Validate dates
        if (DateTime.Parse(room.CheckoutDate) <= DateTime.Parse(room.CheckInDate))
        {
            Console.WriteLine("Checkout date must be after checkin date");
            return;
        }

        // Calculate nights
        room.Nights = (int)(DateTime.Parse(room.CheckoutDate) - DateTime.Parse(room.CheckInDate)).TotalDays;

        // Check for conflicts
        for (int i = 0; i < currentbookings; i++)
        {
            if (rooms[i].id == room.id)
            {
                if ((DateTime.Parse(room.CheckInDate) < DateTime.Parse(rooms[i].CheckoutDate)) &&
                    (DateTime.Parse(room.CheckoutDate) > DateTime.Parse(rooms[i].CheckInDate)))
                {
                    Console.WriteLine("Room is already booked for the selected dates");
                    return;
                }
            }
        }

        rooms[currentbookings] = room;
        currentbookings++;  // FIXED: Increment the counter!
        Console.WriteLine("Room booked successfully!");
    }

    public void CancelBooking(int roomid)
    {
        for (int i = 0; i < currentbookings; i++)
        {
            if (rooms[i].id == roomid)
            {
                for (int j = i; j < currentbookings - 1; j++)
                {
                    rooms[j] = rooms[j + 1];
                }
                rooms[currentbookings - 1] = null;
                currentbookings--;
                Console.WriteLine("Booking cancelled successfully!");
                return;
            }
        }
        Console.WriteLine("Room ID not found!");
    }

    public void UpdateBooking(string guestname, string mealplan, string checkin, string checkout, int roomid)
    {
        for (int i = 0; i < currentbookings; i++)
        {
            if (rooms[i].id == roomid)
            {
                rooms[i].guestname = guestname;
                rooms[i].CheckInDate = checkin;
                rooms[i].CheckoutDate = checkout;
                rooms[i].MealPlan = mealplan;
                rooms[i].Nights = (int)(DateTime.Parse(checkout) - DateTime.Parse(checkin)).TotalDays;
                Console.WriteLine("Booking updated successfully!");
                return;
            }
        }
        Console.WriteLine("Room ID not found!");
    }

    public void ViewAllBookings()
    {
        if (currentbookings == 0)
        {
            Console.WriteLine("No bookings found.");
            return;
        }
        for (int i = 0; i < currentbookings; i++)
        {
            Console.WriteLine($"Room ID: {rooms[i].id}, Guest: {rooms[i].guestname}, Type: {rooms[i].Type}, Check-In: {rooms[i].CheckInDate}, Check-Out: {rooms[i].CheckoutDate}, Price/Night: {rooms[i].Price}, Total: {rooms[i].calculateroomcost()}, Meal Plan: {rooms[i].MealPlan}");
        }
    }

    public void ViewUpcomingBookings()
    {
        bool found = false;
        for (int i = 0; i < currentbookings; i++)
        {
            if (DateTime.Parse(rooms[i].CheckInDate) > DateTime.Now)
            {
                Console.WriteLine($"Room ID: {rooms[i].id}, Guest: {rooms[i].guestname}, Type: {rooms[i].Type}, Check-In: {rooms[i].CheckInDate}, Check-Out: {rooms[i].CheckoutDate}, Price/Night: {rooms[i].Price}, Total: {rooms[i].calculateroomcost()}, Meal Plan: {rooms[i].MealPlan}");
                found = true;
            }
        }
        if (!found) Console.WriteLine("No upcoming bookings.");
    }

    public decimal ApplySeasonalPricing(Room room)
    {
        DateTime checkindate = DateTime.Parse(room.CheckInDate);
        decimal adjprices = room.calculateroomcost();
        if (checkindate.Month == 12 || checkindate.Month == 1)
            adjprices += adjprices * 0.30m;
        else if (checkindate.Month >= 6 && checkindate.Month <= 8)
            adjprices += adjprices * 0.20m;
        return adjprices;
    }

    public decimal ApplyMealPlanCharges(Room room)
    {
        decimal mealcharges = 0;
        switch (room.MealPlan)
        {
            case "Breakfast": mealcharges = 500 * room.Nights; break;
            case "Lunch": mealcharges = 1500 * room.Nights; break;
            case "Dinner": mealcharges = 1500 * room.Nights; break;
            case "Breakfast and Dinner": mealcharges = 3500 * room.Nights; break;
            case "Breakfast Lunch and Dinner": mealcharges = 5000 * room.Nights; break;
        }
        return mealcharges;
    }

    public decimal ApplyACCharges(Room room)
    {
        return room.IsAC ? 1000 * room.Nights : 0;
    }

    public decimal ApplyReturningCustomerDiscount(Room room, bool isReturningCustomer)
    {
        if (isReturningCustomer)
        {
            return (room.calculateroomcost() + ApplyMealPlanCharges(room) + ApplyACCharges(room) + ApplySeasonalPricing(room)) * 0.10m;
        }
        return 0;
    }

    public decimal calculatetax(Room rooms)
    {
        return (rooms.calculateroomcost() + ApplyMealPlanCharges(rooms) + ApplyACCharges(rooms) + ApplySeasonalPricing(rooms)) * 0.07m;
    }

    public decimal CalculateFinalTotalRevenue(bool isReturningCustomer)
    {
        decimal finaltotal = 0;
        for (int i = 0; i < currentbookings; i++)
        {
            decimal roomcost = rooms[i].calculateroomcost();
            decimal mealcharges = ApplyMealPlanCharges(rooms[i]);
            decimal accharges = ApplyACCharges(rooms[i]);
            decimal seasonalpricing = ApplySeasonalPricing(rooms[i]);
            decimal discount = ApplyReturningCustomerDiscount(rooms[i], isReturningCustomer);
            decimal tax = calculatetax(rooms[i]);
            finaltotal += (roomcost + mealcharges + accharges + seasonalpricing - discount + tax);
        }
        return finaltotal;
    }
}

public class Program
{
    public static void Main(string[] args)
    {
        hotelbooking hotel = new hotelbooking(5);

        Console.WriteLine("=== Welcome to the Hotel Booking System ===\n");

        bool isRunning = true;
        while (isRunning)
        {
            Console.WriteLine("\n--- MENU ---");
            Console.WriteLine("1. Book a new room");
            Console.WriteLine("2. Cancel a booking");
            Console.WriteLine("3. Update a booking");
            Console.WriteLine("4. View all bookings");
            Console.WriteLine("5. View upcoming bookings");
            Console.WriteLine("6. Generate revenue report");
            Console.WriteLine("7. Exit");
            Console.Write("\nEnter your choice: ");

            string input = Console.ReadLine();

            if (!int.TryParse(input, out int choice))
            {
                Console.WriteLine("Invalid input! Please enter a number.");
                continue;
            }

            switch (choice)
            {
                case 1:
                    Room newRoom = new Room();

                    Console.Write("Enter Room ID: ");
                    if (!int.TryParse(Console.ReadLine(), out int roomId))
                    {
                        Console.WriteLine("Invalid Room ID!");
                        break;
                    }
                    newRoom.id = roomId;

                    Console.Write("Enter Guest Name: ");
                    newRoom.guestname = Console.ReadLine();

                    Console.WriteLine("Select Room Type: 1=Single, 2=Double, 3=Suite, 4=Deluxe");
                    Console.Write("Choice: ");
                    if (!int.TryParse(Console.ReadLine(), out int typeChoice) || typeChoice < 1 || typeChoice > 4)
                    {
                        Console.WriteLine("Invalid room type!");
                        break;
                    }
                    newRoom.Type = typeChoice == 1 ? "Single" : typeChoice == 2 ? "Double" : typeChoice == 3 ? "Suite" : "Deluxe";

                    Console.Write("Enter Price per Night: ");
                    if (!decimal.TryParse(Console.ReadLine(), out decimal price) || price <= 0)
                    {
                        Console.WriteLine("Invalid price!");
                        break;
                    }
                    newRoom.Price = price;

                    Console.Write("Enter Check-In Date (MM/DD/YYYY): ");
                    string checkin = Console.ReadLine();
                    if (!DateTime.TryParse(checkin, out DateTime checkinDate))
                    {
                        Console.WriteLine("Invalid date format!");
                        break;
                    }
                    newRoom.CheckInDate = checkin;

                    Console.Write("Enter Check-Out Date (MM/DD/YYYY): ");
                    string checkout = Console.ReadLine();
                    if (!DateTime.TryParse(checkout, out DateTime checkoutDate))
                    {
                        Console.WriteLine("Invalid date format!");
                        break;
                    }
                    newRoom.CheckoutDate = checkout;

                    Console.Write("Is AC required? (yes/no): ");
                    newRoom.IsAC = Console.ReadLine()?.ToLower() == "yes";

                    Console.WriteLine("Select Meal Plan:");
                    Console.WriteLine("1=None, 2=Breakfast, 3=Lunch, 4=Dinner");
                    Console.WriteLine("5=Breakfast and Dinner, 6=All Meals");
                    Console.Write("Choice: ");
                    if (!int.TryParse(Console.ReadLine(), out int mealChoice) || mealChoice < 1 || mealChoice > 6)
                    {
                        Console.WriteLine("Invalid meal plan!");
                        break;
                    }
                    newRoom.MealPlan = mealChoice == 1 ? "None" : mealChoice == 2 ? "Breakfast" :
                                       mealChoice == 3 ? "Lunch" : mealChoice == 4 ? "Dinner" :
                                       mealChoice == 5 ? "Breakfast and Dinner" : "Breakfast Lunch and Dinner";

                    hotel.BookRoom(newRoom);
                    break;

                case 2:
                    Console.Write("Enter Room ID to cancel: ");
                    if (!int.TryParse(Console.ReadLine(), out int cancelId))
                    {
                        Console.WriteLine("Invalid Room ID!");
                        break;
                    }
                    hotel.CancelBooking(cancelId);
                    break;

                case 3:
                    Console.Write("Enter Room ID to update: ");
                    if (!int.TryParse(Console.ReadLine(), out int updateId))
                    {
                        Console.WriteLine("Invalid Room ID!");
                        break;
                    }

                    Console.Write("Enter new Guest Name: ");
                    string newGuest = Console.ReadLine();

                    Console.Write("Enter new Check-In Date (MM/DD/YYYY): ");
                    string newCheckin = Console.ReadLine();

                    Console.Write("Enter new Check-Out Date (MM/DD/YYYY): ");
                    string newCheckout = Console.ReadLine();

                    Console.Write("Enter new Meal Plan: ");
                    string newMeal = Console.ReadLine();

                    hotel.UpdateBooking(newGuest, newMeal, newCheckin, newCheckout, updateId);
                    break;

                case 4:
                    hotel.ViewAllBookings();
                    break;

                case 5:
                    hotel.ViewUpcomingBookings();
                    break;

                case 6:
                    Console.Write("Is customer returning? (yes/no): ");
                    bool isReturning = Console.ReadLine()?.ToLower() == "yes";
                    decimal revenue = hotel.CalculateFinalTotalRevenue(isReturning);
                    Console.WriteLine($"\nFinal Total Revenue: ${revenue:F2}");
                    break;

                case 7:
                    isRunning = false;
                    Console.WriteLine("Goodbye!");
                    break;

                default:
                    Console.WriteLine("Invalid choice! Please select 1-7.");
                    break;
            }
        }
    }
}