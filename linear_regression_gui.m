function linear_regression_gui()
    % Create the GUI figure
    fig = figure('Name', 'Linear Regression GUI', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % Create the data input panels
    dataPanel = uipanel('Title', 'Data Input', 'Position', [0.05, 0.45, 0.4, 0.5]);
    uicontrol('Parent', dataPanel, 'Style', 'text', 'String', 'x:', 'Position', [10, 60, 20, 20]);
    uicontrol('Parent', dataPanel, 'Style', 'text', 'String', 'y:', 'Position', [10, 10, 20, 20]);
    xEdit = uicontrol('Parent', dataPanel, 'Style', 'edit', 'Position', [35, 60, 150, 20]);
    yEdit = uicontrol('Parent', dataPanel, 'Style', 'edit', 'Position', [35, 10, 150, 20]);

    % Create the model selection panel
    modelPanel = uipanel('Title', 'Model Selection', 'Position', [0.55, 0.45, 0.4, 0.5]);
    modelText = uicontrol('Parent', modelPanel, 'Style', 'text', 'String', 'Select Model:', 'Position', [10, 60, 100, 20]);
    modelPopup = uicontrol('Parent', modelPanel, 'Style', 'popup', 'String', {'Linear', 'Exponential', 'Power', 'Growth'}, 'Position', [120, 60, 100, 20]);

    % Create the compute button
    computeButton = uicontrol('Style', 'pushbutton', 'String', 'Compute', 'Position', [240, 20, 100, 30], 'Callback', @computeCallback);

    % Create the results panel
    resultsPanel = uipanel('Title', 'Results', 'Position', [0.05, 0.05, 0.9, 0.35]);
    resultsText = uicontrol('Parent', resultsPanel, 'Style', 'text', 'String', 'Results:', 'Position', [10, 10, 60, 20]);
    resultsEdit = uicontrol('Parent', resultsPanel, 'Style', 'edit', 'Position', [80, 10, 400, 200], 'Max', 2, 'HorizontalAlignment', 'left', 'Enable', 'inactive');

    % Function to compute linear regression
    function computeCallback(~, ~)
        % Get the input data and selected model
        xData = str2num(xEdit.String);
        yData = str2num(yEdit.String);
        selectedModel = modelPopup.String{modelPopup.Value};

        % Perform linear regression based on the selected model
        switch selectedModel
            case 'Linear'
                % Linear model: y = a*x + b
                A = [xData' ones(size(xData'))];
                                coeffs = A \ yData';
                yFit = coeffs(1) * xData + coeffs(2);
                rSquared = computeRSquared(yData, yFit);
                
                % Update results
                results = sprintf('Model: Linear\n');
                results = [results sprintf('Coefficients: a = %.4f, b = %.4f\n', coeffs(1), coeffs(2))];
                results = [results sprintf('R-squared: %.4f\n', rSquared)];

            case 'Exponential'
                % Exponential model: y = a * exp(b * x)
                A = [xData' ones(size(xData'))];
                logYData = log(yData);
                coeffs = A \ logYData';
                yFit = exp(coeffs(1) * xData + coeffs(2));
                rSquared = computeRSquared(yData, yFit);
                
                % Update results
                results = sprintf('Model: Exponential\n');
                results = [results sprintf('Coefficients: a = %.4f, b = %.4f\n', exp(coeffs(2)), coeffs(1))];
                results = [results sprintf('R-squared: %.4f\n', rSquared)];

            case 'Power'
                % Power model: y = a * x^b
                A = [log(xData') ones(size(xData'))];
                logYData = log(yData);
                coeffs = A \ logYData';
                yFit = exp(coeffs(2)) .* xData .^ coeffs(1);
                rSquared = computeRSquared(yData, yFit);
                
                % Update results
                results = sprintf('Model: Power\n');
                results = [results sprintf('Coefficients: a = %.4f, b = %.4f\n', exp(coeffs(2)), coeffs(1))];
                results = [results sprintf('R-squared: %.4f\n', rSquared)];

            case 'Growth'
                % Growth model: y = a * exp(b * x)
                A = [xData' ones(size(xData'))];
                sqrtYData = sqrt(yData);
                coeffs = A \ sqrtYData';
                yFit = (coeffs(1) * xData) ./ (coeffs(2) + xData);
                rSquared = computeRSquared(yData, yFit);
                
                % Update results
                results = sprintf('Model: Growth\n');
                results = [results sprintf('Coefficients: a = %.4f, b = %.4f\n', coeffs(1), coeffs(2))];
                results = [results sprintf('R-squared: %.4f\n', rSquared)];
        end

        % Update the results text
        resultsEdit.String = results;

        % Plot the data points and the least squares fit
        figure('Name', 'Linear Regression Results');
        scatter(xData, yData, 'b', 'filled');
        hold on;
        plot(xData, yFit, 'r', 'LineWidth', 2);
        xlabel('x');
        ylabel('y');
        title('Linear Regression Results');
        legend('Data', 'Least Squares Fit');
        hold off;
    end

    % Function to compute the coefficient of determination (R-squared)
    function rSquared = computeRSquared(yData, yFit)
        ssr = sum((yFit - mean(yData)).^2);
        sst = sum((yData - mean(yData)).^2);
        rSquared = ssr / sst;
    end

end



